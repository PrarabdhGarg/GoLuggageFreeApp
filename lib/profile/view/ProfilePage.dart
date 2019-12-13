import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/views/InfoRow.dart';


class ProfilePage extends StatelessWidget {
  Map<String, String> userMap;

  ProfilePage(this.userMap);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          top: BorderSide(
            color: lightGrey,
          )
        )
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Stack(
              children: <Widget>[
                FractionallySizedBox(
                  heightFactor: 0.5,
                  widthFactor: 1.0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonColor,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(100.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200.0),
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/profile.jpg"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  children: <Widget>[
                    infoRow("Name", userMap["name"].toString(), Theme.of(context).textTheme.headline),
                    Divider(color: Colors.grey[300],),
                    Container(height: 30,),
                    infoRow("Mobile Number", userMap["number"].toString(), Theme.of(context).textTheme.headline),
                    Divider(color: Colors.grey[300],),
                    Container(height: 30,),
                    infoRow("Email Address", userMap["email"].toString(), Theme.of(context).textTheme.headline),
                    Container(height: 30,),
                    infoRow("Refferal Code", userMap["userReferral"], Theme.of(context).textTheme.headline),
                    Container(height: 30,),
                    CustomWidgets.customLoginButton(text: "Copy Refferal Code", onPressed: () {
                      Clipboard.setData(ClipboardData(text: userMap["userReferralCode"].toString()));
                      Fluttertoast.showToast(msg: "Copied Referral Code to clipboard");
                    })
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}