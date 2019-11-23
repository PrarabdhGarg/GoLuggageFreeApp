import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> extractListFromJson(List<dynamic> list) {
  List<String> finalList = new List();
  if(list.isNotEmpty) {
    list.forEach((item) => {
      finalList.add(item.toString())
    });
  }
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
  static final String JWT = "JWT_TOKEN";

  static Future<Null> saveUserData({String userId, String name, String email, String mobileNumber, @required String jwt}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(userId != null) {
      await _prefs.setString(USER_ID, userId);
    }
    if(email != null) {
      await _prefs.setString(EMAIL, email);
    }
    if(mobileNumber != null) {
      await _prefs.setString(MOBILE_NUMBER, mobileNumber);
    }
    if(name != null) {
      await _prefs.setString(NAME, name);
    }
    await _prefs.setString(JWT, jwt);
  }

  static Future<String> getUserNumber() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var number = await _prefs.getString(MOBILE_NUMBER);
    if(number != null) {
      return number;
    } else {
      return "";
    }
  }

  static Future<String> getUserEmail() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var email = _prefs.getString(EMAIL);
    if(email != null) {
      return email;
    } else {
      return "";
    }
  }

  static Future<bool> checkUserLoginStatus() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var id = _prefs.getString(JWT);
    if(id != null && id.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<String> getUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var id = _prefs.getString(USER_ID);
    if(id != null && id.isNotEmpty) {
      return id;
    }
    return "";
  }

  static Future<String> getJWT() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var id = _prefs.getString(JWT);
    if(id != null && id.isNotEmpty) {
      return id;
    }
    throw Exception("User not logged in");
  }

  static Future<String> getUserName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var name = _prefs.getString(NAME);
    if(name != null && name.isNotEmpty) {
      return name;
    }
    return "";
  }
}