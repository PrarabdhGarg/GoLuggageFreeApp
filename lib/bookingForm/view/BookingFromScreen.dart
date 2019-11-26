import 'package:flutter/material.dart';
import 'package:go_luggage_free/bookingForm/view/BookingFormPage.dart';
import 'package:url_launcher/url_launcher.dart';

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
                print("Entered onTap");
                String phoneNumber = "+917854866007";
                String url = "whatsapp://send?phone=$phoneNumber";
                await canLaunch(url) ? launch(url) : launch("tel://$phoneNumber");
                // await FlutterLaunch.launchWathsApp(phone: "8369276419", message: "");
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: BookingFormPage(price, storeId),
        ),
      ),
    );
  }
}