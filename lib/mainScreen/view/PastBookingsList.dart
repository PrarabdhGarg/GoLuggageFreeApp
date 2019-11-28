import 'package:flutter/material.dart';
import 'package:go_luggage_free/bookingTicketInfoScreen/view/BookingTicketInfoScreen.dart';
import 'package:go_luggage_free/mainScreen/model/BookingTicketDAO.dart';
import 'package:go_luggage_free/shared/database/models/BookingTicket.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:go_luggage_free/shared/utils/SharedPrefsHelper.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PastBookings extends StatefulWidget {
  @override
  _PastBookingsState createState() => _PastBookingsState();
}

class _PastBookingsState extends State<PastBookings> {
  // TODO Change capital or small capital D to small D
  // TODO Change Hard-coded userId
  // Add fields for storeImages, and ownerImage
  // String userId = "5dc73841aff11c0017963b5b";
  String getBookings = """
  query GetBookings(\$userId: String!) {
    bookings(consumer: \$userId) {
      _id
      bookingId
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
        ownerDetail
      }
      netStorageCost
      checkInTime
      checkOutTime
      bookingPersonName
      numberOfBags
      numberOfDays
      userGovtId
      createdAt
    }
  }
  """;
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FutureBuilder<String>(
        future: getUserId(),
        builder: (context, snapShot) {
          if(snapShot.connectionState == ConnectionState.done) {
            print("Snapshot Status = Done with id = ${snapShot.data.toString()}");
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                border: Border(
                  top: BorderSide(color: lightGrey,)
                )
              ),
              child: Query(
                options: QueryOptions(
                  document: getBookings,
                  fetchPolicy: FetchPolicy.networkOnly,
                  variables: {
                    'userId': snapShot.data.toString(),
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
                  // print("Result = ${result.data.toString()}");
                  List<dynamic> bookings = result.data['bookings'];
                  print("Recived Bookings = ${bookings.toString()}");
                  var list = BookingTickets.fromMap(bookings).list;
                  BookingTicketDAO.insertBookingTickets(list);
                  if(bookings.length == 0) {
                    return Center(child: Text("No Bookings Made Yet. Please Try again later", style: Theme.of(context).textTheme.headline,),);
                  }
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context,_,__) => BookingTicketInfoScreen(bookings[index]["_id"])));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => BookingTicketInfoScreen(bookings[index]["_id"])));
                        },
                        child: BookingWidget(BookingTicket.fromJson(bookings[index])),
                      );
                    },
                  );
                },
              ),
            );
          } else {
            print("Connection status is not Done. Showing loading icon");
            return Center(
              child: CircularProgressIndicator(),
            );
          }
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
              color: Theme.of(context).backgroundColor,
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
                      Container(
                        child: Text("Booking Id: " + bookingTicket.bookingId ?? "", style: Theme.of(context).textTheme.body1,),
                        padding: EdgeInsets.only(bottom: 4.0),
                      ),
                      Container(
                        child: Text(bookingTicket.storageSpace.displayLocation + " Cloakroom" ?? "", style: Theme.of(context).textTheme.headline,),
                        padding: EdgeInsets.only(bottom: 4.0),
                      ),
                      Container(
                        child: Text(bookingTicket.storageSpace.name ?? "", style: Theme.of(context).textTheme.body1,),
                        padding: EdgeInsets.only(bottom: 4.0),
                      ),
                      Container(
                        child: Text(getHumanReadableDate(DateTime.fromMicrosecondsSinceEpoch(int.parse(bookingTicket.createdAt) * 1000)) ?? "", style: Theme.of(context).textTheme.body1,),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.all(4.0),
                      padding: EdgeInsets.all(4.0),
                      child: Text("Completed", style: TextStyle(color: Colors.lightGreen),),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.all(4.0),
                        padding: EdgeInsets.all(4.0),
                        child: Text("\u20B9 "+bookingTicket.netStorageCost.round().toString(), style: Theme.of(context).textTheme.headline,),
                      ),
                    ),
                  ],
                )
                /*Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.network(imageBaseUrl+bookingTicket.storageSpace.ownerImage),
                  ),
                )*/
              ],
            ), 
          )
        ],
      ),
    );
  }

  Future<String> getUserId() async {
    String id = await SharedPrefsHelper.getCustomerId();
    print("Recived Id = $id");
    return id;
  }
}