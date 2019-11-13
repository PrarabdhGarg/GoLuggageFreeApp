import 'package:go_luggage_free/mainScreen/model/StorrageSpacesDAO.dart';
import 'package:go_luggage_free/shared/database/AppDatabase.dart';
import 'package:go_luggage_free/shared/database/models/BookingTicket.dart';
import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';
import 'package:sqflite/sqflite.dart';

class BookingTicketDAO {
  static Future<bool> insertBookingTickets(List<BookingTicket> list) async {
    final Database _database = await AppDatabase.databaseProvider.getDatabase();
    for(BookingTicket ticket in list) {
      try {
        var map = ticket.toMap();
        var result = await _database.insert('BookingTickets', map, conflictAlgorithm: ConflictAlgorithm.replace);
        print("Result for inserting booking ${ticket.id} = $result");
      } catch(e) {
        print("Exception in inserting ${ticket.id} = ${e.toString()}");
        return false;
      }
    }
    return true;
  }

  static Future<BookingTicket> getBookingTicket(String ticketId) async {
    final Database _database = await AppDatabase.databaseProvider.getDatabase();
    List<Map<String, dynamic>> result = await _database.rawQuery("""
      SELECT * FROM BookingTickets JOIN Storages ON BookingTickets.storageSpaceId=Storages.id WHERE BookingTickets.id = ?
    """, [ticketId]);
    print("Result of Booking Ticket Query = ${result.toString()}");
    BookingTicket bookingTicket;
    if(result != null) {
      StorageSpace storageSpace = await StorageSpacesDAO.getStorageSpace(result[0]["storageSpaceId"]);
      print("Result for Storage Space = ${storageSpace.toString()}");
      bookingTicket = BookingTicket.fromDatabaseResult(result[0], storageSpace);
      print("Final Booking Ticket = ${bookingTicket.toString()}");
    }
    return bookingTicket;
  }
 }