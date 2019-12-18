import 'package:flutter/material.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorChecker.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorListener.dart';
import 'package:http/http.dart' as http;

class NetworkRespoonseHandler {
  static void handleResponse({@required Function(String) onSucess, http.Response response, @required NetworkErrorListener errorListener}) async {
    if(response != null) {
      print("Response Status Code = ${response.statusCode}");
      print("Response body = ${response.body}");
      if(response.statusCode == 200 || response.statusCode == 201) {
        onSucess(response.body);
      } else {
        if(errorListener != null) {
          NetworkErrorChecker(respoonseBody: response.body, networkErrorListener: errorListener);
        }
        else {
          errorListener.onAlertMessageRecived(message: "Unknown error occoured. Please try after some time. If the problem persists, contact support@goluggagefree.com", title: "Error");
          // throw Exception("Obtained null error listener\n${response.statusCode}\n${response.body}\n${response.request}");
        }
      }
    }
  }
}