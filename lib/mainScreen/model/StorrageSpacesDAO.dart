import 'package:go_luggage_free/shared/database/AppDatabase.dart';
import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';
import 'package:sqflite/sqflite.dart';

class StorageSpacesDAO {
  static Future<bool> insertStorageSpaces(List<StorageSpace> list) async {
    final Database _database = await AppDatabase.databaseProvider.getDatabase();
    for(StorageSpace space in list) {
      var map = space.toMap();
      try {
        var result = await _database.insert('Storages', map, conflictAlgorithm: ConflictAlgorithm.replace);
        print("Result for id = ${space.id} = ${result}");
      } catch (e) {
        print("Exception in inderting ${space.id} = ${e.toString()}");
      }
    }
    return true;
  }
}