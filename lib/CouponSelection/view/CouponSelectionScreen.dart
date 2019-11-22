import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_luggage_free/CouponSelection/model/Coupon.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:http/http.dart' as http;
import 'package:go_luggage_free/shared/utils/Constants.dart';

class CouponSelectionScreen extends StatefulWidget {
  String name;
  String userGovtId;
  int numberOfBags;
  String checkInTime;
  String checkOutTime;
  String storageSpaceId;

  CouponSelectionScreen({
    @required this.name,
    @required this.userGovtId,
    @required this.checkInTime,
    @required this.checkOutTime,
    @required this.numberOfBags,
    @required this.storageSpaceId
  });

  @override
  _CouponSelectionScreenState createState() => _CouponSelectionScreenState();
}

class _CouponSelectionScreenState extends State<CouponSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coupons", style: Theme.of(context).textTheme.title,),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border(
            top: BorderSide(
              color: lightGrey
            )
          )
        ),
        child: FutureBuilder<List<Coupon>>(
          future: getApplicableCoupons(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              print("Connection Status = Done");
              return ListView.builder(

              );
            } else if(snapshot.connectionState == ConnectionState.waiting) {
              print("Entered Waiting state");
              return Center(child: CircularProgressIndicator(),);
            } else {
              print("Other Connection State");
              return Center(child: Text("Some Error Occoured. Try Again Later"),);
            }
          },
        ),
      ),
    );
  }

  Future<List<Coupon>> getApplicableCoupons() async {
    var body = {
      "booking": {
        "bookingPersonName": widget.name,
        "userGovtId": widget.userGovtId,
        "numberOfBags": widget.numberOfBags,
        "checkInTime": widget.checkInTime,
        "checkOutTime": widget.checkOutTime,
        "storageSpace": widget.storageSpaceId
      }
    };
    String jwt = await SharedPrefsHelper.getJWT();
    var response = await http.post(getTokensForBooking, body: body, headers: {HttpHeaders.authorizationHeader: jwt});
    
  }
}