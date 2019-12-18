import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_luggage_free/auth/mobileVerification/view/MobileVerificationScreen.dart';
import 'package:go_luggage_free/auth/resetPassword/ResetPasswordScreen.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/mainScreen/view/MainScreen.dart';
import 'package:go_luggage_free/shared/network/NetworkResponseHandler.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorChecker.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorListener.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart' as prefix0;
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:go_luggage_free/shared/utils/SharedPrefsHelper.dart';
import 'package:go_luggage_free/shared/views/StandardAlertBox.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: Theme.of(context).textTheme.title),
        leading: Container(child: Image.asset("assets/images/logo.png"),padding: EdgeInsets.all(8.0),),
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
      body: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
  
}

class _LoginScreenState extends State<LoginScreen> implements NetworkErrorListener {

  bool isLoading;
  TextEditingController phoneController = new TextEditingController(text: "");
  TextEditingController passwordController = new TextEditingController(text: "");
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _LoginScreenState() {
    this.isLoading = false;
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return Center(child: CircularProgressIndicator(),);
    } else {
      return SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border(
              top: BorderSide(color: lightGrey,)
            )
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(32),
                  child: Image.asset("assets/images/logo.png"),
                ),
                Flexible(
                  flex: 1,
                  child: CustomWidgets.customEditText(controller: phoneController, context: context, hint: "Please Enter Phone Number", label: "Phone Number", validator: Validators.phoneValidator, inputType: TextInputType.phone),
                ),
                Flexible(
                  flex: 1,
                  child: CustomWidgets.customEditText(context: context, controller: passwordController, hint: "Please Enter Password", label: "Password", validator: Validators.passwordValidator, obscureText: true),
                ),
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.only(right: 16.0),
                      child: FlatButton(
                        onPressed: onForgotPasswordPressed,
                        child: Text("Forgot Password?", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.lightBlue),),
                      ),
                    ),
                  )
                ),
                Container(height: 24,),
                CustomWidgets.customLoginButton(text: "Login", onPressed: onLoginPressesed),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Center(child: Text("OR", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),),
                ),
                CustomWidgets.customLoginButton(text: "Create New Account", onPressed: onSignUpPressed),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<Null> checkLoginStatus() async {
    bool isLoggedIn = await SharedPrefsHelper.checkUserLoginStatus();
    if(isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(0)));
    }
  }

  onForgotPasswordPressed() async {
    if(phoneController.text.isEmpty) {
      onToastMessageRecived(message: "Please Enter the phone Number");
    } else if(Validators.phoneValidator(phoneController.text) !=  null) {
      onToastMessageRecived(message: Validators.phoneValidator(phoneController.text));
    } else {
      setState(() {
        isLoading = true;
      });
      await SharedPrefsHelper.saveUserData(mobileNumber: phoneController.text, jwt: "");
      var response = await http.post(forgotPasswordOtpGenerate, body: {
        "number": phoneController.text
      }, headers: {"X-Version": versionCodeHeader});
      NetworkRespoonseHandler.handleResponse(
        response: response,
        errorListener: this,
        onSucess: (responseBody) {
          setState(() {
          this.isLoading = false;
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPasswordScreen(), settings: RouteSettings(name: "ForgotPasswordScreen")));
        }
      );
    }
  }

  onLoginPressesed() async {
    if(_formKey.currentState.validate()) {
      setState(() {
        this.isLoading = true;
      });
      print("Entered onTap Listener for the login button");
      var response = await http.post(logInUrl, body: {
        "phone_number": phoneController.text,
        "password": passwordController.text }, headers: {"X-Version": versionCodeHeader});
      print("Response Status = ${response.statusCode}");
      NetworkRespoonseHandler.handleResponse(
        errorListener: this,
        response: response,
        onSucess: (responseBody) async {
          var map = jsonDecode(responseBody)["user"];
          String jwt = jsonDecode(responseBody)["token"];
          print("Map = ${map}");
          var userId = map["_id"];
          var coustomerId = jsonDecode(responseBody)['customer']['_id'];
          var name = map["name"];
          var email = map["email"];
          var mobileNumber = map["mobile_number"].toString();
          var userReferral = jsonDecode(responseBody)["referralCode"].toString();
          print("Recived Referral = $userReferral");
          print("REcivedData = $userId\t$name\t$email\t$mobileNumber");
          await SharedPrefsHelper.saveUserData(userId: userId, name: name, email: email, mobileNumber: mobileNumber, jwt: jwt, customerId: coustomerId);
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(0), settings: RouteSettings(name: "HomeScreen")));
        }
      );
    }
  }

  onSignUpPressed() async {
    // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context,_,__) => MobileVerificationScreen()));
    Navigator.push(context, MaterialPageRoute(builder: (context) => MobileVerificationScreen(), settings: RouteSettings(name: "MobileVerificationScreen")));
  }

  @override
  void onAlertMessageRecived({String title = "Alert", String message}) {
    setState(() {
      this.isLoading = false;
    });
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
    setState(() {
      this.isLoading = false;
    });
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
    setState(() {
      this.isLoading = false;
    });
    print("Entered Function for displaying toast");
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG
    );
  }
}