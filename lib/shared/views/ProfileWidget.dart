import 'package:flutter/material.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      color: buttonColor,
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 8.0),
              padding: EdgeInsets.symmetric(horizontal: 100.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200.0),
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/profile.jpg"),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(userName, style: TextStyle(color: Colors.black),),
          )
        ],
      ), 
    );
  }
}