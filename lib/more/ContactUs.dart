import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String phoneNumber = "+917854866007";
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us", style: Theme.of(context).textTheme.title,),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed:() => Navigator.pop(context, false)
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(4.0),
              child: FlatButton(
                child: Row(children: <Widget>[
                  Container(
                    child: Icon(Icons.message, size: 36.0,),
                    margin: EdgeInsets.only(right: 8.0),
                  ),
                  Text("Chat with us", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.blue), textAlign: TextAlign.start,),
                ],),
                onPressed: () async {
                  String url = "whatsapp://send?phone=$phoneNumber";
                  await canLaunch(url) ? launch(url) : Fluttertoast.showToast(msg: "WhatsApp is unavailable on your phone. Please call us instead");
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: FlatButton(
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(Icons.phone, size: 36,),
                      margin: EdgeInsets.only(right: 8.0),
                    ),
                    Text("Call Us", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.blue), textAlign: TextAlign.start,),
                  ],
                ),
                onPressed: () async {
                  launch("tel://$phoneNumber");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}