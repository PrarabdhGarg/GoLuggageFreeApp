import 'package:go_luggage_free/shared/database/AppDatabase.dart';
import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';
import 'package:sqflite/sqflite.dart';

class StorageSpacesDAO {
  static Future<bool> insertStorageSpaces(List<StorageSpace> list) async {
    final Database _database = await AppDatabase.databaseProvider.getDatabase();
    for(StorageSpace space in list) {
      var map = space.toMap();
      try {
        for(String image in space.storeImages) {
          await _database.insert('Media', {"id": space.id, "storageId": image}, conflictAlgorithm: ConflictAlgorithm.replace);
        }
        print("Inserting in to database = ${map["location"].toString()}");
        var result = await _database.insert('Storages', map, conflictAlgorithm: ConflictAlgorithm.replace);
        print("Result for id = ${space.id} = ${result}");
      } catch (e) {
        print("Exception in inderting ${space.id} = ${e.toString()}");
      }
    }
    return true;
  }

  static Future<StorageSpace> getStorageSpace(String id) async {
    print("Recived id = ${id}");
    final Database _database = await AppDatabase.databaseProvider.getDatabase();
    List<Map<String, dynamic>> result = await _database.rawQuery("""
      SELECT * FROM Storages JOIN Media ON Storages.id=Media.id WHERE Storages.id = ?
    """, [id]);
    if(result.isEmpty) {
      result = await _database.rawQuery("""SELECT * FROM Storages WHERE Storages.id = ?""", [id]);
    }
    print("Result of query = " + result.toString());
    StorageSpace storageSpace;
    if(result != null) {
      List<String> images = new List();
      result.forEach((item) {
        images.add(item["storageId"]);
      });
      print("Result [0]" + result[0].toString());
      storageSpace = StorageSpace.fromDatabaseResponse(result[0], images);
    }
    print(storageSpace);
    return storageSpace;
  }
}