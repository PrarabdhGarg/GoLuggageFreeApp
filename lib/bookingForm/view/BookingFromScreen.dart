import 'package:flutter/material.dart';
import 'package:go_luggage_free/bookingForm/view/BookingFormPage.dart';

class BookingFormScreen extends StatelessWidget {
  double price;
  GlobalKey<ScaffoldState> _key = new GlobalKey();
  String storeId;

  BookingFormScreen(this.price, this.storeId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed:() => Navigator.pop(context, false)
        ),
        title: Text("Booking", style: Theme.of(context).textTheme.title,),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: BookingFormPage(price, storeId),
      ),
    );
  }
}