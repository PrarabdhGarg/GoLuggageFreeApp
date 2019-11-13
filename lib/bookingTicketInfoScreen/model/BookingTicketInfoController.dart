import 'package:flutter/cupertino.dart';
import 'package:go_luggage_free/mainScreen/model/BookingTicketDAO.dart';
import 'package:go_luggage_free/shared/database/models/BookingTicket.dart';

class BookingInfoScreenController with ChangeNotifier {
  String ticketId;
  bool isLoading;
  BookingTicket bookingTicket;
  String displayMessage = "";

  BookingInfoScreenController(this.ticketId) {
    this.isLoading = true;
    getTicketInfo();
  }

  Future<Null> getTicketInfo() async {
    try {
      bookingTicket = await BookingTicketDAO.getBookingTicket(ticketId);
      if(bookingTicket != null) {
        displayMessage = "Unable to fetch data. Please try again after some time";
      }
    } catch(e) {
      displayMessage = "Exception Occoured. ${e.toString()}";
    }
    isLoading = false;
    notifyListeners();
  }

  resetDisplayMessage() {
    this.displayMessage = "";
  }
}