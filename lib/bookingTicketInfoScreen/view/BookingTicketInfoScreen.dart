import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_luggage_free/bookingTicketInfoScreen/model/BookingTicketInfoController.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:go_luggage_free/shared/views/InfoRow.dart';
import 'package:provider/provider.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

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
          title: Text("Booking", style: Theme.of(context).textTheme.title,),
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
      Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border(
                top: BorderSide(color: lightGrey,)
            )
        ),
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height * 5.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                    autoPlay: false,
                    scrollDirection: Axis.horizontal,
                    items: _controller.bookingTicket.storageSpace.storeImages.map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(imageBaseUrl+image),
                                  fit: BoxFit.fitWidth
                              ),
                            ),
                          );
                        },
                      );
                    }).toList()
                ),
              ),
              Container(
                margin: EdgeInsets.all(24.0),
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: HexColor("#DDDDDD"),
                      spreadRadius: 1.0,
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 2.0),
                            child: Text("Booking ID: ", style: Theme.of(context).textTheme.body1,),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text("${_controller.bookingTicket.bookingId}", style: TextStyle(color: Colors.red),),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(bottom: 8.0),
                                  child: Text(_controller.bookingTicket.storageSpace.displayLocation, style: Theme.of(context).textTheme.headline)
                              ),
                              Container(
                                  margin: EdgeInsets.only(bottom: 8.0),
                                  child: Text(_controller.bookingTicket.storageSpace.name, style: Theme.of(context).textTheme.body2,)
                              ),
                              Container(height: 10,),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(left: 8.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 3.0,
                                          blurRadius: 3.0,
                                          color: lightGrey
                                      )
                                    ],
                                    shape: BoxShape.circle,
                                    /* border: Border(
                                    bottom: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                    top: BorderSide(color: Colors.black),
                                  ), */
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: FadeInImage(
                                      fit: BoxFit.cover,
                                      placeholder: AssetImage("assets/images/profile.jpg"),
                                      image: NetworkImage(imageBaseUrl + _controller.bookingTicket.storageSpace.ownerImage),
                                    ),
                                  ),
                                ),
                                Text(_controller.bookingTicket.storageSpace.ownerName, style: Theme.of(context).textTheme.body1, textAlign: TextAlign.center,)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(color: Colors.grey[300],),
                    FlatButton(
                      onPressed: () async {
                        print("Map URL = ${_controller.bookingTicket.storageSpace.longAddress}");
                        if(await canLaunch(_controller.bookingTicket.storageSpace.location)) {
                          print("Opening google maps");
                          await launch(_controller.bookingTicket.storageSpace.location);
                        } else {
                          print("Cannot open google maps");
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 8.0),
                              width: 24,
                              height: 24,
                              child: Icon(Icons.location_on, color: Theme.of(context).buttonColor,),
                            ),
                            Expanded(
                              child: Text(_controller.bookingTicket.storageSpace.longAddress, style: Theme.of(context).textTheme.body1,),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey[300],),
                    infoRow("Name", _controller.bookingTicket.bookingPersonName != "null" ? _controller.bookingTicket.bookingPersonName : "NA", Theme.of(context).textTheme.headline),
                    Divider(color: Colors.grey[300],),
                    infoRow("Goverment ID", _controller.bookingTicket.userGovtId, Theme.of(context).textTheme.headline),
                    Divider(color: Colors.grey[300],),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                            child: Column(
                              children: <Widget>[
                                Text("Check In " + getUserReadableTime(DateTime.fromMicrosecondsSinceEpoch(int.parse(_controller.bookingTicket.checkInTime) * 1000))),
                                Text(getHumanReadableDate(DateTime.fromMicrosecondsSinceEpoch(int.parse(_controller.bookingTicket.checkInTime) * 1000)), style: TextStyle(fontSize: 16, color: Colors.black),),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                            size: 34.0,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                            child: Column(
                              children: <Widget>[
                                Text("Check Out " + getUserReadableTime(DateTime.fromMicrosecondsSinceEpoch(int.parse(_controller.bookingTicket.checkOutTime) * 1000))),
                                Text(getHumanReadableDate(DateTime.fromMicrosecondsSinceEpoch(int.parse(_controller.bookingTicket.checkOutTime) * 1000)), style: TextStyle(fontSize: 16, color: Colors.black),),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(color: Colors.grey[300],),
                    infoRow("Number of Days", _controller.bookingTicket.numberOfDays.toString(), Theme.of(context).textTheme.headline),
                    Divider(color: Colors.grey[300],),
                    infoRow("Number of Bags", _controller.bookingTicket.numberOfBags.toString(), Theme.of(context).textTheme.headline),
                    Divider(color: Colors.grey[300],),
                    infoRow("Price(Per Bag Per Day)", (_controller.bookingTicket.storageSpace.costPerHour * 24).round().toString(), Theme.of(context).textTheme.headline),
                    Divider(color: Colors.grey[300],),
                    infoRow("Sub Total", "\u20B9 " + (_controller.bookingTicket.numberOfBags * _controller.bookingTicket.numberOfDays * _controller.bookingTicket.storageSpace.costPerHour * 24).round().toString(), Theme.of(context).textTheme.headline),
                    Divider(color: Colors.grey[300],),
                    infoRow("Total", "\u20B9 " + _controller.bookingTicket.netStorageCost.round().toString(), Theme.of(context).textTheme.headline),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget showErrorMessage(String errorMessage) {
    return Center(child: Text(errorMessage),);
  }
}