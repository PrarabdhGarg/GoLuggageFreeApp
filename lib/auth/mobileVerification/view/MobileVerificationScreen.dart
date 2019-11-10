import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/auth/signUp/view/SignUpScreen.dart';

class MobileVerificationScreen extends StatefulWidget {
  @override
  _MobileVerificationScreenState createState() => _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  bool isOtpVerification = false;
  bool isLoading = false;
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController phoneController = new TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sign Up"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed:() => Navigator.pop(context, false)
        ),
      ),
      body: isOtpVerification ? otpVerificationWidget(isLoading) : phoneNumberWidget(context),
    );
  }

  Widget otpVerificationWidget(bool isLoading) {

  }

  Widget phoneNumberWidget(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(32),
                child: Image.network("https://goluggagefree.com/image/hero-img-blue.png"),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Please Enter Phone Number'
                  ),
                  controller: phoneController,
                  validator: Utils.phoneValidator,
                ),
              ),
            ),
            CustomWidgets.customLoginButton(text: "Submit", onPressed: onSubmitPressed)
          ],
        ),
      ),
    );
  }

  onSubmitPressed() async {
    if(_formKey.currentState.validate()) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
    }
  }
}