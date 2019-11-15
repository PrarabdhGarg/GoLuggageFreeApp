import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> extractListFromJson(List<dynamic> list) {
  List<String> finalList = new List();
  list.forEach((item) => {
    finalList.add(item.toString())
  });
  return finalList;
}
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class SharedPrefsHelper {
  static final  String USER_ID = "USER_ID";
  static final  String EMAIL = "EMAIL";
  static final  String MOBILE_NUMBER = "MOBILE_NUMBER";
  static final  String NAME = "NAME";

  static Future<Null> saveUserData({String userId, String name, String email, String mobileNumber}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(userId != null) {
      await prefs.setString(USER_ID, userId);
    }
    if(email != null) {
      await prefs.setString(EMAIL, email);
    }
    if(mobileNumber != null) {
      await prefs.setString(MOBILE_NUMBER, mobileNumber);
    }
    if(name != null) {}
    await prefs.setString(NAME, name);
  }
}