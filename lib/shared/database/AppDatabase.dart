import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

/* This class is only used to provide a singleton instance of the datatbase.
 * If the instance doesn't exist, it tries to make a new instance by opening the database.
 * If the database also doesn't exist, it creates one.
 * Note however that the data within the database is not manupilated directly throught this class.
 * Data manupilation is done with other classes labeled as DAO's(Data Access Objects), which are classes
 * that control data manuplation over a specific set of tables that are relationslly related.
 * This pattern is similar to the one followed by the famous android library Room.
 */

class AppDatabase {

  /* This is a private constructor of the class as we need only one instance of this class running
   * The single instance of class is neccessary as it ensures a single instance of the SQL database, which
   * is in turn neccessary because creating and opening databased are heavy operations 
   */ 
  AppDatabase._();

  static final AppDatabase databaseProvider = AppDatabase._();
  static Database _database;

  /* This function uses the concept of lazy loading to initialize a new instance of the database, only when the
   * instance was not previously created, other-wise it returns the previous instance only 
   */
  Future<Database> getDatabase() async {
    if(_database != null) {
      return _database;
    }
    return await initDatabase();
  }

  Future<Database> initDatabase() async {
    String databasePath = path.join(await getDatabasesPath(), 'database.db');
    _database = await openDatabase(databasePath, version: 1, onCreate: (db,_) async {
      await db.execute('''PRAGMA foreign_keys = ON''');
    });
    return _database;
  }
}