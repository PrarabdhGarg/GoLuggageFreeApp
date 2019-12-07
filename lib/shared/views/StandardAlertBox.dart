import 'package:flutter/material.dart';

class StandardAlertBox extends StatelessWidget {
  String title;
  String message;

  StandardAlertBox({this.title = "Alert", @required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.title,),
      content: Container(child: Text(message, style: Theme.of(context).textTheme.body1,)),
      actions: <Widget>[
        FlatButton(
          child: Text("Ok", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}