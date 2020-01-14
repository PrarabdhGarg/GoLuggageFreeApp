import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MobileVerificationController with ChangeNotifier {
  bool isLoading;
  bool isOTPVerification;
  String message;
  String _verificationId;
  TextEditingController phoneController;

  MobileVerificationController() { 
    this.isLoading = false;
    this.isOTPVerification = false;
    this.message = "";
    this.phoneController = new TextEditingController(text: "");
  }

  void verifyPhoneNumber() async {
    this.isLoading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {
      print("Mobile Number Verification Completed");
      // _firebaseAuth.signInWithCredential(phoneAuthCredential);
      print("Recived PhoneAuth Credential = ${phoneAuthCredential}");
    };

    final PhoneVerificationFailed verificaitonFailed = (AuthException exception) {
      this.isLoading = false;
      this.message = exception.message.toString();
      print("Exception Occoured while signing in = ${exception.toString()}");
      notifyListeners();
    };

    final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      isLoading = false;
      isOTPVerification = true;
      notifyListeners();
      print("Verification Id recived = ${verificationId}");
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout autoretrivalTimeout = (String verificationId) {
      print("Auto Reterival Timed Out, VerificationId = ${verificationId}");
      _verificationId = verificationId;
    };

    /* await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificaitonFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: autoretrivalTimeout
    ); */
  }

  resetDisplayMessage() {
    this.message = "";
  }
}