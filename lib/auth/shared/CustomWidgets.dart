import 'package:flutter/material.dart';

class CustomWidgets {
  static Widget customLoginButton({String text, Function onPressed}) {
    return Flexible(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.all(Radius.circular(25.0))
        ),
        child: FlatButton(
          child: SizedBox(
            width: 200.0,
            height: 50.0,
            child: Center(child: Text(text, 
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              )
            ),
         ),
          color: Colors.transparent,
          onPressed: onPressed,
        ),
      ),
    );
  }
}