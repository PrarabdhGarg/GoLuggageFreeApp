import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorListener.dart';

class NetworkErrorChecker {
  String respoonseBody;
  NetworkErrorListener networkErrorListener;

  NetworkErrorChecker({@required this.respoonseBody, @required this.networkErrorListener}) {
    // The actual code is not written within the constructor because I wanted the chekcing to be
    // asynchronous, which was not possible in case of a cosntructor.
    // Hence, a finction is used. However, since the function needs to be called everytime the object
    // is initialized, I call the function from the constructor itself
    checkBodyForErrors();
  }

  void checkBodyForErrors() async {
    if(respoonseBody != null && respoonseBody.isNotEmpty) {
      var responseJson = jsonDecode(respoonseBody);
      var messageObject = jsonEncode(responseJson["message"]);
      print("Recived message object = $messageObject");
      if(messageObject != null) {
        var message = jsonDecode(messageObject);
        String title = message["title"].toString();
        String messageBody = message["description"].toString();
        String displayType = message["displayType"].toString();
        switch(displayType) {
          case "ALERT": {
            print("Recived an alert error with body = $messageBody \n title = $title");
            networkErrorListener.onAlertMessageRecived(title: title, message: messageBody);
            break;
          }
          case "SNACKBAR": {
            print("Recived an snackbar error with body = $messageBody \n title = $title");
            networkErrorListener.onSnackbarMessageRecived(message: messageBody);
            break;
          }
          case "TOAST": {
            print("Recived an toast error with body = $messageBody \n title = $title");
            networkErrorListener.onToastMessageRecived(message: messageBody);
            break;
          }
          default: {
            print("Recived an default error with body = $messageBody \n title = $title");
            networkErrorListener.onAlertMessageRecived(message: "something went wrong. Please restart your app");
            break;
          }
        }
      }
    }
  }
}