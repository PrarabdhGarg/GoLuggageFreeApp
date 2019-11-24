import 'package:flutter/material.dart';

Widget infoRow(String text1, String text2, TextStyle style) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Container(child: Text(text1, style: style,), padding: EdgeInsets.only(left: 8.0),),
      ),
      Container(child: Text(text2), padding: EdgeInsets.only(right: 8.0),)
    ],
  );
}