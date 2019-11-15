import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:go_luggage_free/bookingForm/view/CustomCounter.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:intl/intl.dart';

class BookingFormPage extends StatefulWidget {
  int price;

  BookingFormPage(this.price);

  @override
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController _nameController = new TextEditingController(text: "");
  TextEditingController _govtIdNumberController = new TextEditingController(text: "");
  TextEditingController _checkInController = new TextEditingController(text: "");
  TextEditingController _checkOutController = new TextEditingController(text: "");
  DateTime _checkIn;
  DateTime _checkOut;
  int _numberOfBags = 1;
  int _numberOfDays = 0;
  final format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          customEditText("Name", "Please enter your name", Validators.nameValidator, _nameController),
          customEditText("Govt. ID(Aadhar, DL or Passport)", "Enter a valid Govt. Id", Validators.govtIdValidator, _govtIdNumberController),
          Row(
            children: <Widget>[
              Container(width: 24.0,),
              Container(child: Text("Number of Bags"),),
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
          Row(
            children: <Widget>[
              Container(width: 24.0,),
              Container(child: Text("Check-In Time"),),
              Container(width: 40.0,),
              Expanded(
                flex: 1,
                child: DateTimeField(
                  format: format,
                  controller: _checkInController,
                  decoration: InputDecoration(
                    hintText: "Check In"
                  ),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
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
                        _checkInController.text = currentValue.toString();
                        try {
                          _numberOfDays = _checkOut.difference(_checkIn).inDays;
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
          Row(
            children: <Widget>[
              Container(width: 24.0,),
              Container(child: Text("Check-out Time"),),
              Container(width: 40.0,),
              Expanded(
                flex: 1,
                child: DateTimeField(
                  format: format,
                  controller: _checkOutController,
                  decoration: InputDecoration(
                    hintText: "Check Out"
                  ),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
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
                        _checkOutController.text = currentValue.toString();
                        try {
                          _numberOfDays = _checkOut.difference(_checkIn).inDays;
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
          Divider(),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 24.0),
                child: Text("Number of Days"),
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
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 24.0),
                child: Text("Total Amount"),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.only(right: 24.0),
                    child: Text("${_numberOfBags*_numberOfDays*24*widget.price}"),
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(25.0))
              ),
              child: FlatButton(
                child: Text("Book Now", style: TextStyle(color: Colors.white),),
                onPressed: () {
                  if(_formKey.currentState.validate()) {
                    // TODO Open Razor pay sdk
                  }
                }
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget customEditText(String label, String hint, Function validator, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        obscureText: true,
        controller: controller,
        validator: validator,
      ),
    );
  }
}