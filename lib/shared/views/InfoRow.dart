import 'package:flutter/material.dart';

Widget infoRow(String text1, String text2, TextStyle style) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Text(text1, style: style,),
      ),
      Text(text2)
    ],
  );
}