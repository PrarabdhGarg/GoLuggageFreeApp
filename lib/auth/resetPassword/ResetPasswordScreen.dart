import 'package:flutter/material.dart';
import 'package:go_luggage_free/auth/resetPassword/ResetPasswordPage.dart';
import 'package:go_luggage_free/more/ContactUs.dart';
import 'package:url_launcher/url_launcher.dart';

class ResetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Reset Password", style: Theme.of(context).textTheme.title,),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed:() => Navigator.pop(context, false)
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
      body: ResetPasswordPage(),
    );
  }
}