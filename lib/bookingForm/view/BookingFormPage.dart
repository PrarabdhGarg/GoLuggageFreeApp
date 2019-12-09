import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_luggage_free/CouponSelection/view/CouponSelectionScreen.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/bookingForm/view/CustomCounter.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/bookingTicketInfoScreen/view/BookingTicketInfoScreen.dart';
import 'package:go_luggage_free/mainScreen/model/BookingTicketDAO.dart';
import 'package:go_luggage_free/shared/database/models/BookingTicket.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorChecker.dart';
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
  String selectedUserGovtIdType = "AADHAR";
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
                      initialValue: checkInController.text != "" ? DateTime.parse(checkInController.text) : DateTime.now(),
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
                            calculateStorageCost();
                            try {
                              numberOfDays = calculateNumberOfDays(_checkIn, _checkOut);
                            } catch(e) {
                              print("Exception while calculating number of days" + e.toString());
                              numberOfDays = numberOfDays;
                              calculateStorageCost();
                            }
                            print("Number Of days = ${numberOfDays}");
                          });
                          return DateTimeField.combine(date, time) ?? DateTime.parse(checkInController.text);
                        } else {
                          return currentValue ?? DateTime.parse(checkInController.text);
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
                              numberOfDays = calculateNumberOfDays(_checkIn, _checkOut);
                              calculateStorageCost();
                            } catch(e) {
                              print(e.toString());
                              numberOfDays = numberOfDays;
                              calculateStorageCost();
                            }
                            print("Number Of days = ${numberOfDays}");
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
                              calculateStorageCost();
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
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 24.0, right: 24.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: _termsAndConditionsAccepted ? Theme.of(context).buttonColor : HexColor("#5874a1")
              ),
              child: FlatButton(
                onPressed: _termsAndConditionsAccepted ? () {
                  try {
                    onBookingButtonPressed();
                  } catch(e) {
                    print("Ecxeption inside try for booking button, \n $e");
                  }
                } : null,
                child: Text("Book Now", style: Theme.of(context).textTheme.button,),
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
          ],
        ),
      ),
    );
  }

  onBookingButtonPressed() async {
    if(formKey.currentState.validate()) {
      print("Entered Booking Button Presed");
      setState(() {
        isLoading = true;
      });
      String jwt = await SharedPrefsHelper.getJWT();
      String couponId = "";
      try {
        couponId = selectedCoupon.id;
      } catch(e) {
        print("Ecxeption in getting id for slected coupon");
        couponId = "";
      }
      // print("Making a booking with coupon id = ${selectedCoupon.id}");
      var responde = await http.post(makeBooking+"${widget.storageSpaceId}/book", body: json.encode({
        "numberOfBags": numberOfBags,
        "checkInTime": _checkIn.toIso8601String(),
        "checkOutTime": _checkOut.toIso8601String(),
        "userGovtIdType": "Aadhaar",
        "userGovtId": govtIdNumber.text,
        "bookingPersonName": nameController.text,
        "couponId": couponId
      }), headers: {HttpHeaders.authorizationHeader: jwt, "Content-Type": "application/json", "X-Version": versionCodeHeader});
      print("Response Code = ${responde.statusCode}");
      print("Response Body = ${responde.body}");
      ticket = bookingTicketFromJson(responde.body.toString());
      NetworkErrorChecker(networkErrorListener: this, respoonseBody: responde.body);
      if(responde.statusCode == 200 || responde.statusCode == 201) {
        String bookingId = await json.decode(responde.body)["_id"];
        var responseForPayment = await http.post(payForBooking + bookingId, headers: {HttpHeaders.authorizationHeader: jwt, "Content-Type": "application/json", "X-Version": versionCodeHeader});
        print(responseForPayment.statusCode);
        print("Response = ${responseForPayment.body}");
        NetworkErrorChecker(networkErrorListener: this, respoonseBody: responseForPayment.body);
        if(responseForPayment.statusCode == 200 || responseForPayment.statusCode == 201) {
          String orderId = jsonDecode(responseForPayment.body)["order_id"];
          String razorpayKey = jsonDecode(responseForPayment.body)["key_id"];
          String transaction_id = jsonDecode(responseForPayment.body)["transaction_id"];
          await SharedPrefsHelper.addTransactionId(transaction_id);
          print("Added Transaction id = ${json.decode(responde.body)["transaction"]}");
          print("Recived Receipt id = ${orderId}");

          String number = await SharedPrefsHelper.getUserNumber();
          String email = await SharedPrefsHelper.getUserEmail();

          // rzp_test_FrEjSYTC6hMJvn
          // rzp_live_Cod208QgiAuDMf
          // ${(_numberOfBags*_numberOfDays*24*widget.price).round()*100}
          var _razorPay = Razorpay();
          _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSucess);
          _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
          _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalEvent);
          print("Price = $price");
          print("Storage Cost = ${calculateStorageCost()}");
          var _options = {
            "key": razorpayKey,
            "amount": calculateStorageCost() * 100,
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
          print("Razor Pay Options = ${_options.toString()}");
          _razorPay.open(_options);
        }
      }  
    }
  }

  Widget couponSelectedWidget() {
    print("Entered Coupon Selected Widget");
    if(couponSelected) {
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
    return Container();
  }

  onAddCouponsButtonPressed() async {
    bool isCouponSelected = await Navigator.push(context, MaterialPageRoute(builder: (context) => CouponSelectionScreen(
      checkInTime: _checkIn.toIso8601String(),
      checkOutTime: _checkOut.toIso8601String(),
      name: nameController.text.toString(),
      numberOfBags: numberOfBags,
      storageSpaceId: widget.storageSpaceId,
      userGovtId: govtIdNumber.text.toString(),
      netStorageCost: price,
    ), settings: RouteSettings(name: "Coupons Selection ")));
    print("Boolean recived from pop = $isCouponSelected");
    if(isCouponSelected) {
      setState(() {
        price = calculateStorageCost();
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
    if(paymentConfirmationResponse.statusCode == 200 || paymentConfirmationResponse.statusCode == 201) {
      print("Payment Validation Recived");
      await BookingTicketDAO.insertBookingTickets([ticket]);
      setState(() {
        isLoading = false;
      });
      // Navigator.of(context).pop(true);
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.push(context, MaterialPageRoute(builder: (context) => BookingTicketInfoScreen(ticket.id), settings: RouteSettings(name: "Ticket${ticket.bookingId}")));
      // TODO handle backstack operations
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

  int calculateStorageCost() {
    int orignalPrice = (numberOfBags*numberOfDays*24*widget.price).round();
    if(selectedCoupon != null) {
      if(selectedCoupon.type == "DISCOUNT" || selectedCoupon.type == "REFERRAL_DISCOUNT") {
        int discount = (orignalPrice * (1 - selectedCoupon.value*0.01)).round();
        setState(() {
          price = discount;
        });
        return discount;
      }
    } else {
      setState(() {
      price = orignalPrice;
    });
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