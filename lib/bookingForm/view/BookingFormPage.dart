import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_luggage_free/CouponSelection/view/CouponSelectionScreen.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/bookingForm/view/CustomCounter.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/bookingTicketInfoScreen/view/BookingTicketInfoScreen.dart';
import 'package:go_luggage_free/mainScreen/model/BookingTicketDAO.dart';
import 'package:go_luggage_free/shared/database/models/BookingTicket.dart';
import 'package:go_luggage_free/shared/network/NetworkResponseHandler.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorListener.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart' as prefix0;
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:go_luggage_free/shared/utils/SharedPrefsHelper.dart';
import 'package:go_luggage_free/shared/views/StandardAlertBox.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BookingFormPage extends StatefulWidget {
  double price;
  String storageSpaceId;

  BookingFormPage(this.price, this.storageSpaceId);

  @override
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> implements NetworkErrorListener {
  DateTime _checkIn = DateTime.now();
  DateTime _checkOut = DateTime.now();
  String selectedUserGovtIdType;
  bool _termsAndConditionsAccepted = false;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  bool isLoading;
  bool couponSelected = false;
  BookingTicket ticket;

  @override
  void initState() {
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: CircularProgressIndicator(),) : Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          top: BorderSide(color: lightGrey,)
        )
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: CustomWidgets.customEditText(label: "Name", hint: "Please enter your name", validator: Validators.nameValidator,controller: nameController, context: context),
            ),
            /*Flexible(
              flex: 1,
              child: CustomWidgets.customEditText(label: "Govt. ID(Aadhar, DL or Passport)", hint: "Enter a valid Govt. Id", validator: Validators.govtIdValidator, controller: govtIdNumber, context: context),
            ),*/
            // TODO align govt id and id no
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 14.0, left: 32.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: <Widget>[
                        // Text("Govt. Id Type", style: Theme.of(context).textTheme.overline.copyWith(fontSize: 12), textAlign: TextAlign.left,),
                        DropdownButton<String>(
                          hint: Text("Govt. ID Type"),
                          underline: Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          isDense: false,
                          isExpanded: false,
                          value: selectedUserGovtIdType,
                          icon: Icon(Icons.arrow_drop_down),
                          items: completeListOfUserGovtIdTypes.map((item) {
                            return DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedUserGovtIdType = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: CustomWidgets.customEditText(label: "ID No.", hint: "Enter a valid Govt. Id", validator: Validators.govtIdValidator, controller: govtIdNumber, context: context),
                  ),
                ],
              ),
            ),
            /*Container(
              margin: EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: "AADHAR",
                icon: Icon(Icons.arrow_drop_down),
                items: completeListOfUserGovtIdTypes.map((item) {
                  return DropdownMenuItem(
                    child: Text(item),
                    value: item,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUserGovtIdType = value;
                  });
                },
              ),
            ),*/
            Container(
              margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(width: 24.0,),
                  Container(child: Text("Check-In Time", style: Theme.of(context).textTheme.headline,),),
                  Container(width: 50.0,),
                  Expanded(
                    flex: 1,
                    child: DateTimeField(
                      format: format,
                      controller: checkInController,
                      initialValue: checkInController.text != "" ? DateTime.parse(checkInController.text) : DateTime.now(),
                      validator: Validators.checkInValidator,
                      onChanged: (DateTime newTime) {
                        _checkIn = newTime;
                      },
                      decoration: InputDecoration(
                        hintText: "Check In"
                      ),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now().subtract(Duration(days: 1)),
                            initialDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime:TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          try {
                            _checkIn = DateTimeField.combine(date, time);
                            numberOfDays = calculateNumberOfDays(_checkIn, _checkOut);
                            calculateStorageCost(false);
                          } catch(e) {
                            print("Exception while calculating number of days" + e.toString());
                            numberOfDays = numberOfDays;
                            calculateStorageCost(false);
                          }
                          try {
                            setState(() {
                              print("Entered set State Checkin");
                              checkInController.text = currentValue.toString();
                              print("Number Of days = ${numberOfDays}");
                            });
                          }catch(e) {
                            print("Exception = $e");
                          }
                          return DateTimeField.combine(date, time) ?? DateTime.parse(checkInController.text);
                        } else {
                          checkInController.text = currentValue?.toString() ?? checkInController.text ?? DateTime.now().toString();
                          return currentValue ?? DateTime.now();
                        }
                      },
                    )
                  ),
                  Container(width: 24.0,)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(width: 24.0,),
                  Container(child: Text("Check-out Time", style: Theme.of(context).textTheme.headline,),),
                  Container(width: 40.0,),
                  Expanded(
                    flex: 1,
                    child: DateTimeField(
                      format: format,
                      initialValue: checkOutController.text != "" ? DateTime.parse(checkOutController.text) : DateTime.now(),
                      controller: checkOutController,
                      validator: Validators.checkOutValidator,
                      onChanged: (DateTime newTime) {
                        print("New Time = ${newTime.toString()}");
                        _checkOut = newTime;
                        try {
                          setState(() {
                            print("Entered set State Checkout");
                            checkOutController.text = newTime?.toString(); 
                            numberOfDays = numberOfDays;
                            print("Number Of days = ${_checkOut.toString()}");
                          });
                        } catch(e) {
                          print("Exception = $e");
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Check Out"
                      ),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now().subtract(Duration(days: 1)),
                            initialDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          try {
                            _checkOut = DateTimeField.combine(date, time);
                            numberOfDays = calculateNumberOfDays(_checkIn, _checkOut);
                            calculateStorageCost(false);
                          } catch(e) {
                            print(e.toString());
                            numberOfDays = numberOfDays;
                            calculateStorageCost(false);
                          }
                          return DateTimeField.combine(date, time);
                        } else {
                          checkOutController.text = currentValue?.toString() ?? checkOutController.text ?? DateTime.now().toString();  
                          return currentValue ?? DateTime.now();
                        }
                      },
                    ),
                  ),
                  Container(width: 24.0,)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(width: 24.0,),
                  Container(
                    child: Text("Number of Bags", style: Theme.of(context).textTheme.headline,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(right: 24.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CustomCounter(
                          initialValue: numberOfBags,
                          decimalPlaces: 0,
                          minValue: 1,
                          maxValue: 10,
                          step: 1,
                          color: Colors.blue,
                          textStyle: TextStyle(fontSize: 18),
                          onChanged: (value) {
                            setState(() {
                              print("Entered Set State with value = ${value}");
                              numberOfBags = value;
                              calculateStorageCost(true);
                            });
                          },
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 24.0),
              child: Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 24.0),
                    child: Text("Number of Days", style: Theme.of(context).textTheme.headline,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 24.0),
                        child: Text("${numberOfDays}"),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 24.0),
                    child: Text("Sub Total", style: Theme.of(context).textTheme.headline,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.only(right: 24.0),
                        child: Text("${(numberOfDays * numberOfBags * 24 * widget.price).round()}"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 24.0),
                    child: Text(selectedCoupon != null ? "Discount" : "", style: Theme.of(context).textTheme.headline,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.only(right: 24.0),
                        child: Text(selectedCoupon != null ? "${(numberOfDays * numberOfBags * 24 * widget.price).round() - price}" : "", style: TextStyle(color: Colors.green),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 24.0),
                    child: Text("Total Amount", style: Theme.of(context).textTheme.headline,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.only(right: 24.0),
                        child: Text("$price"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 8.0),
                  child: Checkbox(
                    value: _termsAndConditionsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAndConditionsAccepted = value;
                      });
                    },
                    activeColor: buttonColor,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Please select this to indicate that you accept our\n",
                            style: Theme.of(context).textTheme.body1
                          ),
                          TextSpan(
                            text: "Terms and Conditions",
                            style: Theme.of(context).textTheme.body1.copyWith(color: buttonColor),
                            recognizer: TapGestureRecognizer()..onTap = () async {
                              await launch("https://goluggagefree.com/terms");
                            }
                          )
                        ]
                      ),
                    ),
                  ),
                )
              ],
            ),
            couponSelectedWidget(),
            /* Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                ),
                child: FlatButton(
                  child: Text("Add Coupons", style: Theme.of(context).textTheme.button,),
                  onPressed: onAddCouponsButtonPressed,
                ),
              ),
            ), */
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: prefix0.buttonColor,
                  width: 2.0
                )
                // color: Theme.of(context).buttonColor
              ),
              child: FlatButton(
                onPressed: onAddCouponsButtonPressed,
                child: Text("Add Coupons", style: Theme.of(context).textTheme.button.copyWith(color: prefix0.buttonColor),),
              ),
            ),
            /* Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 16.0),
                decoration: BoxDecoration(
                  color: _termsAndConditionsAccepted ? Theme.of(context).buttonColor : HexColor("#5874a1"),
                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                ),
                child: FlatButton(
                  child: Text("Book Now", style: Theme.of(context).textTheme.button,),
                  onPressed: _termsAndConditionsAccepted ? onBookingButtonPressed : null
                ),
              ),
            ) */
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: prefix0.buttonColor,
                  width: 2.0
                )
                // color: Theme.of(context).buttonColor
              ),
              child: FlatButton(
                onPressed: onShareReferralCodePressed,
                child: Text("Refer and Earn 25% off", style: Theme.of(context).textTheme.button.copyWith(color: prefix0.buttonColor),),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: _termsAndConditionsAccepted ? Theme.of(context).buttonColor : HexColor("#5874a1")
              ),
              child: FlatButton(
                onPressed: _termsAndConditionsAccepted ? () {
                  try {
                    // showCurrencyDialog();
                    onBookingButtonPressed();
                  } catch(e) {
                    print("Ecxeption inside try for booking button, \n $e");
                  }
                } : null,
                child: Text("Book Now", style: Theme.of(context).textTheme.button,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* showCurrencyDialog() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        int index = 0;
        return AlertDialog(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                onBookingButtonPressed(currencies[index]);
              },
            )
          ],
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 16.0, bottom: 32.0),
                      child: Text("Select Currency to pay", style: Theme.of(context).textTheme.headline,),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 0,
                        groupValue: index,
                        onChanged: (int value) {
                          setState(() {
                            index = value;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16.0),
                        child: Text(currencies[0]),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: index,
                        onChanged: (int value) {
                          setState(() {
                            index = value;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16.0),
                        child: Text(currencies[1]),
                      )
                    ],
                  )
                ],
              );
            },
          ),
        );
      }
    );
  } */

  onShareReferralCodePressed() async {
    String referralCode = await SharedPrefsHelper.getUserReferralCode();
    final DynamicLinkParameters params = DynamicLinkParameters(
      uriPrefix: "https://referrals.goluggagefree.com",
      link: Uri.parse("https://goluggagefree.com?invitedBy=$referralCode"),
      androidParameters: AndroidParameters(
        packageName: "com.goluggagefree.goluggagefree",
        minimumVersion: 9,
        fallbackUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.goluggagefree.goluggagefree")
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: "user-referrals",
        medium: "peer-to-peer",
        source: "android-app"
      )
    );
    final ShortDynamicLink shortLink = await params.buildShortLink();
    final Uri link = shortLink.shortUrl;
    String text = "Download the *GoLuggageFree App*. Find cloakrooms near you and enjoy the city luggage-free! Use my referral code: $referralCode to get 25% off on your first booking. ${link.toString()}";
    /* prefix1.Intent()
      ..setAction(prefix2.Action.ACTION_SEND_MULTIPLE)
      ..setType('text/plain')
      ..putExtra(Extra.EXTRA_TEXT, text)
      ..startActivity().catchError((e) => print(e)); */
    await canLaunch("whatsapp://send?text=$text") ? launch("whatsapp://send?text=$text") : print("Unable to launch whatsApp on phone");
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(msg: "Copied Referral Code to clipboard");
  }

  onBookingButtonPressed() async {
    print("CheckOut = ${_checkOut}");
    String number = await SharedPrefsHelper.getUserNumber();
    try{
    logFormData("Booking Form\nName: ${nameController.text}\nGovtId: ${govtIdNumber.text}\nCheckIn: ${_checkIn}\nCheckOut: ${_checkOut}\nNumberOfBags: ${numberOfBags}\nNumber: $number");
    }catch(e){
      print("Exception = $e");
    }finally{
    if(formKey.currentState.validate()) {
      if((_checkOut?.isAfter(_checkIn) ?? false) && (_checkIn?.isAfter(DateTime.now().subtract(Duration(minutes: 5))) ?? false)) {
        print("Entered correct form condition");
        setState(() {
          isLoading = true;
        });
        String jwt = await SharedPrefsHelper.getJWT();
        String couponId = "";
        try {
          couponId = selectedCoupon.id == "-1" ? selectedCoupon.code : selectedCoupon.id;
        } catch(e) {
          print("Ecxeption in getting id for slected coupon");
          couponId = "";
        }
        // print("Making a booking with coupon id = ${selectedCoupon.id}");
        var responde = await http.post(makeBooking+"${widget.storageSpaceId}/book", body: json.encode({
          "numberOfBags": numberOfBags,
          "checkInTime": _checkIn?.toIso8601String(),
          "checkOutTime": _checkOut?.toIso8601String(),
          "userGovtIdType": "Aadhaar",
          "userGovtId": govtIdNumber.text,
          "bookingPersonName": nameController.text,
          "couponId": couponId,
          // "currency": currency ?? "INR"
        }), headers: {HttpHeaders.authorizationHeader: jwt, "Content-Type": "application/json", "X-Version": versionCodeHeader});
        NetworkRespoonseHandler.handleResponse(
          response: responde,
          errorListener: this,
          onSucess: (responseBody) async {
            ticket = bookingTicketFromJson(responseBody.toString());
            String bookingId = await json.decode(responseBody)["_id"];
            var responseForPayment = await http.post(payForBooking + bookingId, headers: {HttpHeaders.authorizationHeader: jwt, "Content-Type": "application/json", "X-Version": versionCodeHeader});
            NetworkRespoonseHandler.handleResponse(
              response: responseForPayment,
              errorListener: this,
              onSucess: (responseBody1) async {
                String orderId = jsonDecode(responseBody1)["order_id"];
                String razorpayKey = jsonDecode(responseBody1)["key_id"];
                String transaction_id = jsonDecode(responseBody1)["transaction_id"];
                await SharedPrefsHelper.addTransactionId(transaction_id);
                print("Added Transaction id = ${json.decode(responseBody)["transaction"]}");
                print("Recived Receipt id = ${orderId}");

                String number = await SharedPrefsHelper.getUserNumber();
                String email = await SharedPrefsHelper.getUserEmail();

                var _razorPay = Razorpay();
                _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSucess);
                _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalEvent);
                var _options = {
                  "key": razorpayKey,
                  "name": "Go Luggage Free",
                  "order_id": orderId,
                  "description": "Cloakrooms near you",
                  "prefill": {
                    "contact": number,
                    "email": email
                  },
                  "theme": {
                    "color": "#0078FF"
                  } 
                };
                _razorPay.open(_options);
              }
            );
          }
        );
      }
      if(_checkOut.isBefore(_checkIn)) {
        Fluttertoast.showToast(msg: "Cannot check-out before check-in time");
      }
      if((_checkIn?.isBefore(DateTime.now().subtract(Duration(minutes: 5))) ?? false)) {
        Fluttertoast.showToast(msg: "Cannot check-in before current time");
      }
    }
  }}

  Widget couponSelectedWidget() {
    print("Entered Coupon Selected Widget");
    print("$couponSelected");
    print("${prefix0.selectedCoupon?.id}");
    if(prefix0.selectedCoupon != null && prefix0.selectedCoupon.id != "-1") {
      return Container(
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
                child: Text(selectedCoupon.title, style: Theme.of(context).textTheme.headline.copyWith(color: selectedCoupon.isUseable ? Colors.black : Colors.grey))
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(selectedCoupon.description, style: Theme.of(context).textTheme.body1.copyWith(color: selectedCoupon.isUseable ? Colors.black : Colors.grey))
            ),

          ],
        ),
      );
    }
    if(prefix0.selectedCoupon != null && selectedCoupon.id == "-1") {
      print("Entered second if");
      return Container(
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
        child: Text(prefix0.selectedCoupon.code),
      );
    }
    return Container();
  }

  onAddCouponsButtonPressed() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => CouponSelectionScreen(
      checkInTime: _checkIn?.toIso8601String(),
      checkOutTime: _checkOut?.toIso8601String(),
      name: nameController.text.toString(),
      numberOfBags: numberOfBags,
      storageSpaceId: widget.storageSpaceId,
      userGovtId: govtIdNumber.text.toString(),
      netStorageCost: price,
    ), settings: RouteSettings(name: "Coupons Selection ")));
    if(prefix0.selectedCoupon != null) {
      setState(() {
        price = calculateStorageCost(true);
        couponSelected = true;
      });
    }
  }

  void _handlePaymentSucess(PaymentSuccessResponse response) async {
    print("Payment Sucessfull");
    String trxnId = await SharedPrefsHelper.getTransactionId();
    String jwt = await SharedPrefsHelper.getJWT();
    print(json.encode({
      "razorpay_payment_id": response.paymentId,
      "razorpay_order_id": response.orderId,
      "razorpay_signature": response.signature,
      "transaction_id": trxnId
    }));
    print("Recived jwt = $jwt");
    var paymentConfirmationResponse = await http.post(razorPayCallbackUrl, body: json.encode({
      "razorpay_payment_id": response.paymentId,
      "razorpay_order_id": response.orderId,
      "razorpay_signature": response.signature,
      "transaction_id": trxnId
    }), headers: {HttpHeaders.authorizationHeader: jwt, "Content-Type": "application/json", "X-Version": versionCodeHeader});
    print(paymentConfirmationResponse.statusCode);
    print(paymentConfirmationResponse.body.toString());
    NetworkRespoonseHandler.handleResponse(
      errorListener: this,
      response: paymentConfirmationResponse,
      onSucess: (responseBody) async {
        print("Payment Validation Recived");
        await BookingTicketDAO.insertBookingTickets([ticket]);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.push(context, MaterialPageRoute(builder: (context) => BookingTicketInfoScreen(ticket.id), settings: RouteSettings(name: "Ticket${ticket.bookingId}")));
      }
    );
  }

  @override
  void onAlertMessageRecived({String title = "Alert", String message}) {
    setState(() {
      isLoading = false;
    });
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
    setState(() {
      isLoading = false;
    });
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
    setState(() {
      isLoading = false;
    });
    print("Entered Function for displaying toast");
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG
    );
  }

  int calculateStorageCost(bool x) {
    calculateNumberOfDays(_checkIn, _checkOut);
    int orignalPrice = (numberOfBags*numberOfDays*24*widget.price).round();
    if(selectedCoupon != null) {
      if(selectedCoupon.type == "DISCOUNT" || selectedCoupon.type == "REFERRAL_DISCOUNT") {
        int discount = (orignalPrice * (1 - selectedCoupon.value*0.01)).round();
        if(x) {
          setState(() {
            price = orignalPrice - discount;
          });
        } else {
          price = orignalPrice - discount;
        }
        return orignalPrice - discount;
      }
    } else {
      if(x) {
        setState(() {
          price = orignalPrice;
        });
      } else {
        price = orignalPrice;
      }
    return orignalPrice;  
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Error in making payment ${response.code.toString()}");
    if(response.code == 2) {
      setState(() {
        this.isLoading = false;
      });
    }
  }

  void _handleExternalEvent(ExternalWalletResponse response) {
    print("External Event to handle");
  }
}