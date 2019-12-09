import 'package:flutter_launcher_icons/constants.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';

class Validators {
  static DateTime checkInTime;

  static String passwordValidator(String password) {
    if(password == null) return "Enter non-null Password";
    if(password.isEmpty) return "Password cannot be empty";
    if(password.length < 7) return "Password should be of atlest 8 characters";
    if(password.contains(' ')) return "Spaces not allowed";
    return null;
  }

  static String phoneValidator(String phone) {
    phone = phone.trim();
    if(phone == null) return "Enter non-null Phone number";
    if(phone.isEmpty) return "Phone number is required";
    // if(phone.length != 10) return "Enter 10 digit number";
    if(!(RegExp(r'^-?[0-9]+$').hasMatch(phone))) return "Invalid";
    return null;
  }

  static String emailValidator(String email) {
    email = email.trim();
    if(email == null) return "Enter non-null Email";
    if(email.isEmpty) return "Email is Required";
    if(email.length<=3) return "Enter a valid Email";
    if(!email.contains('@')) return "Enter a valid Email";
    if(!email.contains('.')) return "Enter a valid email";
    if(!(RegExp( r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$").hasMatch(email))) return "Invalid";
    return null;
  }

  static String nameValidator(String name) {
    name = name.trim();
    if(name == null) return "Enter non-null name";
    if(name.isEmpty) return "Name cannot be blank";
    if(name.length == 1) return "Enter a valid name";
    if(!(RegExp(r'^[a-zA-Z ]+$').hasMatch(name))) return "Invalid";
    if(name.length > 30) return "Too long"; 
    return null;
  }

  static String govtIdValidator(String govtId) {
    govtId = govtId.trim();
    if(govtId == null) return "Enter non-empty Id";
    if(govtId.isEmpty) return "Enter non-empty Id";
    return null;
  }

  static String otpValidator(String otp) {
    if(otp == null) return "Enter non-null OTP";
    if(otp.isEmpty) return "Enter a non-empty otp";
    if(otp.length != 6) return "Invalid";
    if(!(RegExp(r'^-?[0-9]+$').hasMatch(otp))) return "OTP is numeric only";
    return null;
  }

  static String checkInValidator(DateTime checkIn) {
    print("Recived date time = ${checkIn}");
    print("Text in controller = ${checkInController.text}");
    checkInTime = checkIn;
    if(checkIn == null) return "Enter non-null checkIn Time";
    try {
      if(checkIn.toIso8601String().isEmpty) return "Enter non-empty checkIn Time";
    } catch(e) {
      return "Invalid";
    }
    if(!(checkIn.isAfter(DateTime.now()))) return "You cannot checkIn before Today";
    return null;
  }

  static String checkOutValidator(DateTime checkOut) {
    if(checkInTime == null) return "Select checkIn Time first";
    if(checkOut == null) return "Enter non-empty checkOut Time";
    if(checkOut.toIso8601String().isEmpty) return "CheckOut Time cannot be null";
    if(checkOut.isBefore(checkInTime)) return "CheckOut cannot be before checkIn";
    if(checkOut.isBefore(DateTime.now())) return "CheckOut cannot be before today";
    return null;
  }

  static String referralValidator(String referral) {
    return null;
  }
}