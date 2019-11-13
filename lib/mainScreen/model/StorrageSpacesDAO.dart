import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';
import 'package:sqflite/sqflite.dart';

class StorageSpacesDAO {
  static Future<bool> insertStorageSpaces(List<StorageSpace> list) async {
    bool result = await insertStorageSpaces(list);
    if(result) {
      print("Entered DAO with succesfull insertion");
    }
    return result;
  }
}