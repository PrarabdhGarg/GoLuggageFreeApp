import 'dart:convert';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
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
  TextEditingController codeController = TextEditingController(text: "");

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
  List<String> suggestions = ["Hello", "Hi"];
  bool isLoading;
  String manualCouponCode = "";

  @override
  void initState() {
    getApplicableCoupons();
    getSuggestions();
    this.coupons = [];
    this.isLoading = true;
  }

  Future<Null> getSuggestions() {
    // TODO Implement feature of auto-complete in the future
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
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(4.0),
                  margin: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          child: AutoCompleteTextField<String>(
                            suggestions: suggestions,
                            controller: widget.codeController,
                            itemBuilder: (context, suggestion) => Container(
                              child: Container(
                                padding: EdgeInsets.all(4.0),
                                margin: EdgeInsets.all(4.0),
                                child: Text(suggestion, style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black),),
                              )
                            ),
                            suggestionsAmount: suggestions.length,
                            clearOnSubmit: false,
                            itemFilter: (item, query) {return item.toLowerCase().contains(query.toLowerCase());},
                            textChanged: (String code) {
                              print("Entered text changed");
                              setState(() {
                                widget.codeController.text = code;
                                manualCouponCode = code;
                              });
                            },
                            itemSubmitted: (String code) {
                              print("Entered on Submitted button with $code");
                              setState(() {
                                widget.codeController.text = code;
                                manualCouponCode = code;
                              });
                            },
                            submitOnSuggestionTap: true,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4.0, left: 4.0),
                        margin: EdgeInsets.only(right: 16.0, left: 8.0, top: 8.0),
                        // color: Colors.blueAccent,
                        child: GestureDetector(
                          child: Text("ADD", style: Theme.of(context).textTheme.headline.copyWith(color: Colors.red),),
                          onTap: () {
                            selectedCoupon = Coupon(id: "-1", code: manualCouponCode);
                            print("Entered text = ${widget.codeController.text}\n$manualCouponCode");
                            Navigator.of(context).pop(true);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: coupons.isEmpty ? Center(child: Text("Sorry. No applicable coupons"),) :  Container(
                    child: ListView.builder(
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
                    ),
                  ),
                )
              ],
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