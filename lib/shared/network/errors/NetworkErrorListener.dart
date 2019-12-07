import 'package:flutter/material.dart';

abstract class NetworkErrorListener {
   void onAlertMessageRecived({String title = "Alert", @required String message});

   void onToastMessageRecived({@required String message});

   void onSnackbarMessageRecived({@required String message});
}