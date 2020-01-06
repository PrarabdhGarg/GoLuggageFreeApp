import 'package:go_luggage_free/mainScreen/model/BookingTicketDAO.dart';
import 'package:go_luggage_free/mainScreen/model/StorrageSpacesDAO.dart';
import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';
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
  StorageSpacesDAO _storageSpacesDAO;
  BookingTicketDAO _bookingTicketDAO;

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
    _database = await openDatabase(databasePath, version: 2, onCreate: (db,_) async {
      await db.execute('''PRAGMA foreign_keys = ON''');
      await db.execute('''CREATE TABLE Storages(
        id TEXT PRIMARY KEY NOT NULL,
        name TEXT NOT NULL,
        ownerName TEXT NULL,
        hasCCTV INTEGER NOT NULL,
        address TEXT NULL,
        longAddress TEXT NULL,
        rating REAL NULL,
        costPerHour REAL NOT NULL,
        timings TEXT NOT NULL,
        ownerImage TEXT NULL,
        displayLocation TEXT NULL,
        location TEXT NULL,
        ownerDetail TEXT NULL,
        open INTEGER NOT NULL,
        numOfBookings INTEGER
      )''');
      await db.execute('''CREATE TABLE Media(
        id TEXT,
        storageId TEXT PRIMARY KEY,
        FOREIGN KEY(id) REFERENCES Storages(id)
      )''');
      // TODO: Add non-null assertion to booking Id after testing
      await db.execute('''CREATE TABLE BookingTickets(
        id TEXT PRIMARY KEY NOT NULL,
        bookingId TEXT NULL,
        storageSpaceId TEXT NOT NULL,
        netStorageCost REAL NOT NULL,
        checkInTime TEXT NOT NULL,
        checkOutTime TEXT NOT NULL,
        bookingPersonName TEXT,
        numberOfBags INTEGER,
        numberOfDays INTEGER,
        userGovtId TEXT,
        createdAt TEXT NULL,  
        FOREIGN KEY(storageSpaceId) REFERENCES Storages(id)
      )''');
    }, onUpgrade: (db, oldVersion, newversion) async {
      var batch = db.batch();
      if(oldVersion == 1) {
        _updateDatabaseFrom1to2(batch);
      }
      await batch.commit();
    });
    return _database;
  }

  void _updateDatabaseFrom1to2(Batch batch) {
    batch.execute('ALTER TABLE Storages ADD COLUMN numOfBookings INTEGER DEFAULT 50');
  }

  Future<StorageSpacesDAO> getStorageSpaceDAO() async {
    if(_storageSpacesDAO != null) {
      return _storageSpacesDAO;
    }
    return StorageSpacesDAO();
  }

  Future<BookingTicketDAO> getBookingTicketDAO() async {
    if(_bookingTicketDAO != null) {
      return _bookingTicketDAO;
    }
    return BookingTicketDAO();
  }
}