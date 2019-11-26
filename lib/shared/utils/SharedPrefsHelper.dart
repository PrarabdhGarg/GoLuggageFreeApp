import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static final  String USER_ID = "USER_ID";
  static final  String EMAIL = "EMAIL";
  static final  String MOBILE_NUMBER = "MOBILE_NUMBER";
  static final  String NAME = "NAME";
  static final String JWT = "JWT_TOKEN";
  static final String COUPON = "ACTIVE_COUPON";
  static final String TRXN = "TRANSACTION";

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

  static Future<String> getActiveCouponId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var coupon = _prefs.getString(COUPON);
    if(coupon != null && coupon.isNotEmpty) {
      return coupon;
    }
    return "";
  }

  static Future<Null> addTransactionId(String id) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool result = await _prefs.setString(TRXN, id);
    print("Result for adding = $result");
  }

  static Future<String> getTransactionId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String txn = await _prefs.getString(TRXN);
    print("Recived trxn id = ${txn}");
    if(txn != null && txn.isNotEmpty) {
      return txn;
    }
    return "";
  }
}