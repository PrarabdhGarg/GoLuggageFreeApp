import 'package:flutter/material.dart';
import 'package:go_luggage_free/shared/database/models/BookingTicket.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PastBookings extends StatefulWidget {
  @override
  _PastBookingsState createState() => _PastBookingsState();
}

class _PastBookingsState extends State<PastBookings> {
  String userId = "5d9f413ad90cd60017050d79";
  String getBookings = """
  query GetBookings(\$userId: String!) {
    bookings(consumer: \$userId) {
      _id
      bookingID
      _id
      storageSpace {
        _id
        name
        area {
          _id
          name
        }
        address
        location
        longAddress
        ownerName
        ownerImage
      }
      netStorageCost
      checkInTime
      checkOutTime
      bookingPersonName
      numberOfBags
      numberOfDays
      userGovtId
    }
  }
  """;
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Query(
        options: QueryOptions(
          document: getBookings,
          variables: {
            'userId': userId,
          }
        ),
        builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
          if(result.errors != null) {
            print("Error occoured = ${result.errors.toList().toString()}");
            return Center(child: Text("Error in loading Data. Please try after some time"),);
          }
          if(result.loading) {
            print("Loading the result");
            return Center(child: CircularProgressIndicator(),);
          }
          print("Result = ${result.data.toString()}");
          List<dynamic> bookings = result.data['bookings'];
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              return BookingWidget(BookingTicket.fromJson(bookings[index]));
            },
          );
        },
      ),
    );
  }

  Widget BookingWidget(BookingTicket bookingTicket) {
    bookingTicket.bookingId = bookingTicket.bookingId != null ? bookingTicket.bookingId : "000000";
    return Container(
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
                      Text("Booking Id: " + bookingTicket.bookingId),
                      Text(bookingTicket.storageSpace.name, style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(bookingTicket.storageSpace.longAddress),
                    ],
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.network(imageBaseUrl+bookingTicket.storageSpace.ownerImage),
                  ),
                )
              ],
            ), 
          )
        ],
      ),
    );
  }
}