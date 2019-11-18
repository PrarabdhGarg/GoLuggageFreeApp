import 'package:flutter/material.dart';
import 'package:go_luggage_free/bookingTicketInfoScreen/model/BookingTicketInfoController.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:provider/provider.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';

class BookingTicketInfoScreen extends StatefulWidget {
  String ticketId;

  BookingTicketInfoScreen(this.ticketId);

  @override
  _BookingTicketInfoScreenState createState() => _BookingTicketInfoScreenState();
}

class _BookingTicketInfoScreenState extends State<BookingTicketInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookingInfoScreenController>(
      builder: (BuildContext context) => BookingInfoScreenController(widget.ticketId),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Booking"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black,),
            onPressed:() => Navigator.pop(context, false)
          ),
        ),
        body: BookingTicketInfoPage(),
      ),
    );
  }
}

class BookingTicketInfoPage extends StatefulWidget {
  @override
  _BookingTicketInfoPageState createState() => _BookingTicketInfoPageState();
}

class _BookingTicketInfoPageState extends State<BookingTicketInfoPage> {
  @override
  Widget build(BuildContext context) {
    final BookingInfoScreenController _controller = Provider.of<BookingInfoScreenController>(context);
    return _controller.isLoading ? Center(child: CircularProgressIndicator(),) : 
      _controller.displayMessage.isNotEmpty ? showErrorMessage(_controller.displayMessage) : 
      SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border(
              top: BorderSide(color: lightGrey,)
            )
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 8.0, top: 6.0, right: 8.0, bottom: 6.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: HexColor("#DDDDDD"),
                      spreadRadius: 1.0,
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Booking Id: " + _controller.bookingTicket.bookingId),
                          Text(_controller.bookingTicket.storageSpace.name, style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(_controller.bookingTicket.storageSpace.longAddress),
                        ],
                      ),
                    ),
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.network(imageBaseUrl+_controller.bookingTicket.storageSpace.ownerImage),
                      ),
                    )
                  ],
                ), 
              )
            ],
          ),
        ),
      );
  }

  Widget showErrorMessage(String errorMessage) {
    return Center(child: Text(errorMessage),);
  }
}