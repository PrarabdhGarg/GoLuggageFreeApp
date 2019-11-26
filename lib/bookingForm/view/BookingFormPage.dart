import 'dart:convert';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_luggage_free/CouponSelection/view/CouponSelectionScreen.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/bookingForm/view/CustomCounter.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:go_luggage_free/shared/utils/SharedPrefsHelper.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingFormPage extends StatefulWidget {
  double price;
  String storageSpaceId;

  BookingFormPage(this.price, this.storageSpaceId);

  @override
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController _nameController = new TextEditingController(text: "");
  TextEditingController _govtIdNumberController = new TextEditingController(text: "");
  TextEditingController _checkInController = new TextEditingController(text: "");
  TextEditingController _checkOutController = new TextEditingController(text: "");
  DateTime _checkIn = DateTime.now();
  DateTime _checkOut = DateTime.now();
  int _numberOfBags = 1;
  int _numberOfDays = 0;
  String selectedUserGovtIdType = "AADHAR";
  bool _termsAndConditionsAccepted = false;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 12.0, left: 32.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: <Widget>[
                        Text("Govt. Id Type", style: Theme.of(context).textTheme.overline.copyWith(fontSize: 8), textAlign: TextAlign.left,),
                        DropdownButton<String>(
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
                      validator: Validators.checkInValidator,
                      decoration: InputDecoration(
                        hintText: "Check In"
                      ),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          setState(() {
                            print("Entered set State Checkin");
                            _checkIn = DateTimeField.combine(date, time);
                            checkInController.text = currentValue.toString();
                            try {
                              _numberOfDays = calculateNumberOfDays(_checkIn, _checkOut);
                            } catch(e) {
                              print(e.toString());
                              _numberOfDays = _numberOfDays;
                            }
                            print("Number Of days = ${_numberOfDays}");
                          });
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
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
                      controller: checkOutController,
                      decoration: InputDecoration(
                        hintText: "Check Out"
                      ),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: _checkIn ?? DateTime.now(),
                            initialDate: _checkIn ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          setState(() {
                            print("Entered set State Checkout");
                            _checkOut = DateTimeField.combine(date, time);
                            checkOutController.text = currentValue.toString();
                            try {
                              _numberOfDays = calculateNumberOfDays(_checkIn, _checkOut);
                            } catch(e) {
                              print(e.toString());
                              _numberOfDays = _numberOfDays;
                            }
                            print("Number Of days = ${_numberOfDays}");
                          });
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),
                  ),
                  Container(width: 24.0,)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0, bottom: 48.0),
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
                          initialValue: _numberOfBags,
                          decimalPlaces: 0,
                          minValue: 1,
                          maxValue: 10,
                          step: 1,
                          color: Colors.blue,
                          textStyle: TextStyle(fontSize: 18),
                          onChanged: (value) {
                            setState(() {
                              print("Entered Set State with value = ${value}");
                              _numberOfBags = value;
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
              margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
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
                        child: Text("${_numberOfDays}"),
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
                    child: Text("Total Amount", style: Theme.of(context).textTheme.headline,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.only(right: 24.0),
                        child: Text("${(_numberOfBags*_numberOfDays*24*widget.price).round()}"),
                      ),
                    ),
                  )
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
            Align(
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
            ),
            Align(
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
            )
          ],
        ),
      ),
    );
  }

  onBookingButtonPressed() async {
    setState(() {
      isLoading = true;
    });
    if(formKey.currentState.validate()) {
      String jwt = await SharedPrefsHelper.getJWT();
      String coupon = await SharedPrefsHelper.getActiveCouponId();
      var responde = await http.post(makeBooking+"${widget.storageSpaceId}/book", body: json.encode({
        "numberOfBags": _numberOfBags,
        "checkInTime": _checkIn.toIso8601String(),
        "checkOutTime": _checkOut.toIso8601String(),
        "userGovtIdType": "Aadhaar",
        "userGovtId": govtIdNumber.text,
        "bookingPersonName": nameController.text,
        "couponId": coupon
      }), headers: {HttpHeaders.authorizationHeader: jwt, "Content-Type": "application/json"});
      print("Response Code = ${responde.statusCode}");
      print("Response Body = ${responde.body}");
      String bookingId = await json.decode(responde.body)["_id"];
      // await SharedPrefsHelper.addTransactionId(bookingId);
      var responseForPayment = await http.post(payForBooking + bookingId, headers: {HttpHeaders.authorizationHeader: jwt, "Content-Type": "application/json"});
      print(responseForPayment.statusCode);
      print("Response = ${responseForPayment.body}");
      String orderId = jsonDecode(responseForPayment.body)["order_id"];
      String razorpayKey = jsonDecode(responseForPayment.body)["key_id"];
      print("Added Transaction id = ${json.decode(responde.body)["transaction"]}");
      print("Recived Receipt id = ${orderId}");
      var _razorPay = Razorpay();
      _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSucess);
      _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalEvent);

      String number = await SharedPrefsHelper.getUserNumber();
      String email = await SharedPrefsHelper.getUserEmail();

      // rzp_test_FrEjSYTC6hMJvn
      // rzp_live_Cod208QgiAuDMf
      // ${(_numberOfBags*_numberOfDays*24*widget.price).round()*100}
      var _options = {
        "key": razorpayKey,
        "amount": "100",
        "name": "GoLuggageFree",
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
  }

  onAddCouponsButtonPressed() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CouponSelectionScreen(
      checkInTime: _checkIn.toIso8601String(),
      checkOutTime: _checkOut.toIso8601String(),
      name: nameController.text.toString(),
      numberOfBags: _numberOfBags,
      storageSpaceId: widget.storageSpaceId,
      userGovtId: govtIdNumber.text.toString(),
      netStorageCost: (_numberOfBags*_numberOfDays*24*widget.price).round(),
    ), settings: RouteSettings(name: "Coupons Selection ")));
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
    var paymentConfirmationResponse = await http.post(razorPayCallbackUrl, body: json.encode({
      "razorpay_payment_id": response.paymentId,
      "razorpay_order_id": response.orderId,
      "razorpay_signature": response.signature,
      "transaction_id": trxnId
    }), headers: {HttpHeaders.authorizationHeader: jwt, "Content-Type": "application/json"});
    if(paymentConfirmationResponse.statusCode == 200 || paymentConfirmationResponse.statusCode == 201) {
      print("Payment Validation Recived");
      // TODO handle backstack operations
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Error in making payment ${response.message.toString()}");
  }

  void _handleExternalEvent(ExternalWalletResponse response) {
    print("External Event to handle");
  }
}