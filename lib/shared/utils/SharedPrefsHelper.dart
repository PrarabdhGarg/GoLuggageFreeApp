import 'package:flutter/cupertino.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static final  String USER_ID = "USER_ID";
  static final  String EMAIL = "EMAIL";
  static final  String MOBILE_NUMBER = "MOBILE_NUMBER";
  static final  String NAME = "NAME";
  static final String JWT = "JWT_TOKEN";
  static final String COUPON = "ACTIVE_COUPON";
  static final String TRXN = "TRANSACTION";
  static final String CUST_ID = "CUST_ID";
  static final String REFFERED_BY = "REFFERED_BY";
  static final String USER_REFERRAL = "USER_REFERRAL";

  static Future<Null> saveUserData({String userId, String name, String email, String mobileNumber, @required String jwt, String customerId, String userReferralCode}) async {
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
      userName = await getUserName();
    }
    if(customerId != null) {
      await _prefs.setString(CUST_ID, customerId);
    }
    if(userReferralCode != null) {
      await _prefs.setString(USER_REFERRAL, userReferralCode);
    }
    await _prefs.setString(JWT, "Bearer ${jwt}");
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
    print("Jwt = ${id}");
    if(id != null && id.isNotEmpty && !(id == "Bearer ")) {
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

  static Future<String> getCustomerId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var id = _prefs.getString(CUST_ID);
    if(id != null && id.isNotEmpty) {
      return id;
    }
    throw Exception("User not logged in");
  }

  static Future<Null> addTransactionId(String id) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool result = await _prefs.setString(TRXN, id);
    print("Result for adding = $result");
  }

  static Future<Null> addInvidedById(String id) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(id != null && id.isNotEmpty) {
      bool result = await _prefs.setString(REFFERED_BY, id);
    }
  }

  static Future<String> getInvidedById() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String referredBy = await _prefs.getString(REFFERED_BY);
    print("Recived trxn id = ${referredBy}");
    if(referredBy != null && referredBy.isNotEmpty) {
      return referredBy;
    }
    return "";
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

  static Future<String> getUserReferralCode() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String referral = await _prefs.getString(USER_REFERRAL);
    print("Recived trxn id = ${referral}");
    if(referral != null && referral.isNotEmpty) {
      return referral;
    }
    return "";
  }
}