import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_luggage_free/CouponSelection/model/Coupon.dart';
import 'package:go_luggage_free/CouponSelection/model/Coupon.dart';
import 'package:go_luggage_free/more/ContactUs.dart';
import 'package:go_luggage_free/shared/network/NetworkResponseHandler.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorChecker.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorListener.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:go_luggage_free/shared/utils/SharedPrefsHelper.dart';
import 'package:go_luggage_free/shared/views/StandardAlertBox.dart';
import 'package:http/http.dart' as http;
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponSelectionScreen extends StatefulWidget {
  String name;
  String userGovtId;
  int numberOfBags;
  String checkInTime;
  String checkOutTime;
  String storageSpaceId;
  int netStorageCost;

  CouponSelectionScreen({
    @required this.name,
    @required this.userGovtId,
    @required this.checkInTime,
    @required this.checkOutTime,
    @required this.numberOfBags,
    @required this.storageSpaceId,
    @required this.netStorageCost
  });

  @override
  _CouponSelectionScreenState createState() => _CouponSelectionScreenState();
}

class _CouponSelectionScreenState extends State<CouponSelectionScreen> implements NetworkErrorListener{
  List<Coupon> coupons;
  bool isLoading;

  @override
  void initState() {
    getApplicableCoupons();
    this.coupons = [];
    this.isLoading = true;
  }

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
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 8.0),
              child: Center(
                  child: Text("Need Help?", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black),)
              )
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              child: Center(child: Text("Contact Us", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.blue[900]),)),
              onTap: () async {
                /* print("Entered onTap");
                String phoneNumber = "+917854866007";
                String url = "whatsapp://send?phone=$phoneNumber";
                await canLaunch(url) ? launch(url) : launch("tel://$phoneNumber"); */
                // await FlutterLaunch.launchWathsApp(phone: "8369276419", message: "");
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUs(), settings: RouteSettings(name: "Contact Us Page")));
              },
            ),
          )
        ],
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
        child: isLoading ? Center(child: CircularProgressIndicator(),) :
          coupons.isEmpty ? Center(child: Text("Sorry. No applicable coupons"),) :
            ListView.builder(
              itemCount: coupons.length,
              itemBuilder: (BuildContext context, int index) {
                return FlatButton(
                  onPressed: () {
                    onDiscountCouponTapped(index);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Text(coupons[index].title, style: Theme.of(context).textTheme.headline.copyWith(color: coupons[index].isUseable ? Colors.black : Colors.grey))
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Text(coupons[index].description, style: Theme.of(context).textTheme.body1.copyWith(color: coupons[index].isUseable ? Colors.black : Colors.grey))
                        ),

                      ],
                    ),
                  ),
                );
              }
            )
      ),
    );
  }

  Future<Null> getApplicableCoupons() async {
    print("Entered Future");
    var body = {
      "booking": {
        "bookingPersonName": widget.name,
        "userGovtId": widget.userGovtId,
        "numberOfBags": widget.numberOfBags,
        "checkInTime": widget.checkInTime,
        "checkOutTime": widget.checkOutTime,
        "storageSpace": widget.storageSpaceId,
        "netStorageCost": widget.netStorageCost
      }
    };
    print("Body = ${body.toString()}");
    String jwt = await SharedPrefsHelper.getJWT();
    // String jwt = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZDlmNDEzYWQ5MGNkNjAwMTcwNTBkNzkiLCJpYXQiOjE1NzQ3ODcwMjN9.jrQkXwPEMeRUNwKA-fgM5XAkOtGtARTCXqa39cZIKlU";
    print("Recived user jwt = $jwt");
    var response = await http.post(getTokensForBooking, body: json.encode({
      "booking": {
        "bookingPersonName": widget.name,
        "userGovtId": widget.userGovtId,
        "numberOfBags": widget.numberOfBags,
        "checkInTime": widget.checkInTime,
        "checkOutTime": widget.checkOutTime,
        "storageSpace": widget.storageSpaceId,
        "netStorageCost": widget.netStorageCost
      }
    }), headers: {HttpHeaders.authorizationHeader: jwt, "Content-Type": "application/json", "X-Version": versionCodeHeader});
    print("Response recived");
    print("Reived response code = ${response.statusCode.toString()}");
    print("Recived Body = ${response.body.toString()}");
    NetworkRespoonseHandler.handleResponse(
      response: response,
      errorListener: this,
      onSucess: (responseBody) {
        List<dynamic> useableJSON = jsonDecode(responseBody)["usableCoupons"];
        print("Useable Coupons = ${useableJSON.toList()}");
        List<dynamic> unuseableJSON = jsonDecode(responseBody)["unusableCoupons"];
        print("UnUseable Coupons = ${unuseableJSON.toList()}");
        for(var couponResponse in useableJSON) {
          setState(() {
            coupons.add(Coupon.fromJSON(couponResponse, true));
          });
          print("Returned from factory method");
        }
        for(var couponResponse in unuseableJSON) {
          coupons.add(Coupon.fromJSON(couponResponse, false));
        }
        coupons.sort((a,b) => a.compareTo(b));
        setState(() {
          print("Entered last print state");
          this.coupons = coupons;
          this.isLoading = false;
        });
      }
    );
  }

  onDiscountCouponTapped(int index) async {
    if(coupons[index].isUseable) {
      selectedCoupon = coupons[index];
      Navigator.of(context).pop(true);
    } else {
      Fluttertoast.showToast(msg: "Not Applicable Right Now");
      // TODO Remove this statement and handle this on back pressed
      Navigator.of(context).pop(false);
    }
  }

  @override
  void onAlertMessageRecived({String title = "Alert", String message}) {
    print("Entered functtion for displaying alert Box");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StandardAlertBox(message: message, title: title,);
      }
    );
  }

  @override
  void onSnackbarMessageRecived({String message}) {
    print("Entered Function for displaying snackbar");
    Scaffold.of(context).showSnackBar(SnackBar(
       content: Text(message),
       action: SnackBarAction(
         label: "Ok",
         onPressed: () {
           Navigator.of(context).pop();
         },
       ),
    ));
  }

  @override
  void onToastMessageRecived({String message}) {
    print("Entered Function for displaying toast");
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG
    );
  }
}