import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/auth/signUp/view/SignUpScreen.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';

class MobileVerificationScreen extends StatefulWidget {
  @override
  _MobileVerificationScreenState createState() => _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  bool isOtpVerification = false;
  bool isLoading = false;
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController phoneController = new TextEditingController(text: "");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId = "";
  AuthCredential _authCredential;
  AuthResult _user;
  String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sign Up", style: Theme.of(context).textTheme.title,),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed:() => Navigator.pop(context, false)
        ),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : isOtpVerification ? otpVerificationWidget(context) : phoneNumberWidget(context),
    );
  }

  Widget otpVerificationWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          top: BorderSide(color: lightGrey,)
        )
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(32),
                child: Image.asset("assets/images/logo.png"),
              ),
            ),
            Flexible(
              flex: 1,
              child: CustomWidgets.customEditText(controller: phoneController, context: context, label: "OTP", hint: "Please enter your OTP", validator: Validators.otpValidator, inputType: TextInputType.phone),
            ),
            Container(height: 30,),
            CustomWidgets.customLoginButton(text: "Verify", onPressed: onVerifyRequest)
          ],
        ),
      ),
    );
  }

  Widget phoneNumberWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          top: BorderSide(color: lightGrey,)
        )
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(32),
                child: Image.asset("assets/images/logo.png"),
              ),
            ),
            Flexible(
              flex: 1,
              child: CustomWidgets.customEditText(context: context, controller: phoneController,label: "Phone Number", hint: "Please Enter Phone Number", validator: Validators.phoneValidator, inputType: TextInputType.phone)
            ),
            Container(height: 30,),
            CustomWidgets.customLoginButton(text: "Submit", onPressed: onMobileVerificationPressed)
          ],
        ),
      ),
    );
  }

  onMobileVerificationPressed() async {
    if(_formKey.currentState.validate()) {
      phoneNumber = phoneController.text;
      setState(() {
        this.isLoading = true;
        phoneController.text = "";
      });
      final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) async {
        print("Phone Number Verification Completed");
        _user = await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        _authCredential = phoneAuthCredential;
        print("Recived PhoneAuth Credential = ${phoneAuthCredential}");
        await signInWithFirebase(phoneAuthCredential);
      };

      final PhoneVerificationFailed verificaitonFailed = (AuthException exception) {
        setState(() {
          this.isLoading = false;
        });
        // TODO display appropriate message
        // this.message = exception.message.toString();
        print("Exception Occoured while signing in = ${exception.message.toString()}");
      };

      final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
        print("Verification Id recived = ${verificationId} \n ${forceResendingToken}");
        _verificationId = verificationId;
      };

      final PhoneCodeAutoRetrievalTimeout autoretrivalTimeout = (String verificationId) {
        print("Auto Reterival Timed Out, VerificationId = ${verificationId}");
        setState(() {
          isLoading = false;
          isOtpVerification = true;
        });
      };

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificaitonFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoretrivalTimeout
      );
    } else {
      setState(() {
        this.isLoading = false;
      });
    }
  }

  onVerifyRequest() async {
    print("Code Entered = ${phoneController.text}");
    _authCredential = await PhoneAuthProvider.getCredential(verificationId: _verificationId, smsCode: phoneController.text);
    print("Recived Auth Credential = ${_authCredential.toString()}");
    await signInWithFirebase(_authCredential);
  }

  Future<Null> signInWithFirebase(AuthCredential phoneAuthCredential) async {
    AuthResult result;
    try {
      AuthResult result = await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      print("Recived firebase User != null");
      setState(() {
        this.isLoading = false;
        this.isOtpVerification = false;
      });
      // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context,_,__) => SignUpScreen(phoneNumber)));
      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(phoneNumber), settings: RouteSettings(name: "SignUpScreen")));
    } catch(e) {
      print("${e.toString()}");
      if(e is PlatformException) {
        PlatformException exception = e as PlatformException;
        String message = exception.message;
        // TODO display this message appropriately
      }
      print("Code Verification Falied");
      setState(() {
        this.isLoading = false;
      });
    }
  }
}