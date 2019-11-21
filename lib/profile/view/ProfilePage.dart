import 'package:flutter/material.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';

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
          Container(
            child: Center(
              child: Text("Name: ${userMap["name"]}", style: Theme.of(context).textTheme.headline,),
            ),
          ),
          Container(
            child: Center(
              child: Text("Number: ${userMap["number"]}", style: Theme.of(context).textTheme.headline,),
            ),
          ),
          Container(
            child: Center(
              child: Text("Email: ${userMap["email"]}", style: Theme.of(context).textTheme.headline,),
            ),
          )
        ],
      ),
    );
  }
}