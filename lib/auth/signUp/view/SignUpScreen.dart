import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/mainScreen/view/MainScreen.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorChecker.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorListener.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/SharedPrefsHelper.dart';
import 'package:go_luggage_free/shared/views/StandardAlertBox.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  String phoneNumber;
  String countryCode;

  SignUpScreen(this.phoneNumber, this.countryCode);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> implements NetworkErrorListener {
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController nameController = new TextEditingController(text: "");
  TextEditingController emailController = new TextEditingController(text: "");
  TextEditingController passwordController = new TextEditingController(text: "");
  TextEditingController passwordConfirmationController = new TextEditingController(text: "");
  TextEditingController referralController = new TextEditingController(text: "");

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
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 8.0),
              child: Center(
                  child: Text("Need Help?", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black),)
              )
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              child: Center(child: Text("Contact Us", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.blue[900]),)),
              onTap: () async {
                print("Entered onTap");
                String phoneNumber = "+917854866007";
                String url = "whatsapp://send?phone=$phoneNumber";
                await canLaunch(url) ? launch(url) : launch("tel://$phoneNumber");
                // await FlutterLaunch.launchWathsApp(phone: "8369276419", message: "");
              },
            ),
          )
        ],
      ),
      body: signUpPage(context),
    );
  }

  Widget signUpPage(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: lightGrey,
            )
          ),
          color: Theme.of(context).backgroundColor
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(32),
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
              Flexible(
                flex: 1,
                child: CustomWidgets.customEditText(controller: nameController, context: context, label: "Name", hint: "Please enter your name", validator: Validators.nameValidator),
              ),
              Flexible(
                flex: 1,
                child: CustomWidgets.customEditText(context: context, controller: emailController, label: "Email", hint: "Please enter a valid email", validator: Validators.emailValidator),
              ),
              Flexible(
                flex: 1,
                child: CustomWidgets.customEditText(controller: passwordController, context: context, label: "Password", hint: "Please Select a password", validator: Validators.passwordValidator, obscureText: true),
              ),
              Flexible(
                flex: 1,
                child: CustomWidgets.customEditText(context: context, controller: passwordConfirmationController, hint: "Please confirm your password", label: "Confirm Password", validator: Validators.passwordValidator, obscureText: true),
              ),
              Flexible(
                flex: 1,
                child: CustomWidgets.customEditText(context: context, controller: referralController, label: "Referral Code", hint: "Please Enter referral Code if any", validator: Validators.referralValidator),
              ),
              Container(height: 30,),
              CustomWidgets.customLoginButton(text: "Sign Up", onPressed: onSignUpPressed)
            ],
          ),
        ),
      ),
    );
  }
  

  Future<Null> onSignUpPressed() async {
    if(_formKey.currentState.validate() && passwordController.text == passwordConfirmationController.text) {
      await SharedPrefsHelper.addInvidedById(referralController.text);
      String referralCode = await SharedPrefsHelper.getInvidedById();
      print("Referral Code recived while signUp = ${referralCode}");
      var result = await http.post(signUpUrl, body: {
          "name": nameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "mobile_number": widget.phoneNumber,
          "mobile_number_countryCode": widget.countryCode,
          "userType": "CUSTOMER",
          "referralCode": referralCode,
      }, headers: {"X-Version": versionCodeHeader});
      NetworkErrorChecker(networkErrorListener: this, respoonseBody: result.body);
      if(result.statusCode == 201) {
        print("Sign-Up sucessful");
        var body = jsonDecode(result.body);
        print("Body Recived = $body");
        await SharedPrefsHelper.saveUserData(name: body["user"]["name"].toString(), mobileNumber: body["user"]["mobile_number"].toString(), email: body["user"]["email"].toString(), userId: body["user"]["_id"].toString(), jwt: body["token"].toString(), customerId: body["customer"]["_id"], userReferralCode: body["referralCode"].toString());
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(0), settings: RouteSettings(name: "HomePage")));
      }
    }
  }

  @override
  void onAlertMessageRecived({String title = "Alert", String message}) {
    print("Entered functtion for displaying alert Box");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StandardAlertBox(message: message, title: title,);
      }
    );
  }

  @override
  void onSnackbarMessageRecived({String message}) {
    print("Entered Function for displaying snackbar");
    Scaffold.of(context).showSnackBar(SnackBar(
       content: Text(message),
       action: SnackBarAction(
         label: "Ok",
         onPressed: () {
           Navigator.of(context).pop();
         },
       ),
    ));
  }

  @override
  void onToastMessageRecived({String message}) {
    print("Entered Function for displaying toast");
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG
    );
  }
}
