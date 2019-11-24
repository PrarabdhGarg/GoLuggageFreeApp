import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_luggage_free/auth/mobileVerification/view/MobileVerificationScreen.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/mainScreen/view/MainScreen.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart' as prefix0;
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: Theme.of(context).textTheme.title),
        leading: Container(child: Image.asset("assets/images/logo.png"),padding: EdgeInsets.all(8.0),),
      ),
      body: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
  
}

class _LoginScreenState extends State<LoginScreen> {

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
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border(
            top: BorderSide(color: lightGrey,)
          )
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
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

  onLoginPressesed() async {
    if(_formKey.currentState.validate()) {
      var response = await http.post(logInUrl, body: {
        "phone_number": phoneController.text,
        "password": passwordController.text });
      print("Response Status = ${response.statusCode}");
      if(response.statusCode == 200) {
        var map = jsonDecode(response.body)["user"];
        String jwt = "Bearer" + jsonDecode(response.body)["token"];
        print("Map = ${map}");
        var userId = map["_id"];
        var name = map["name"];
        var email = map["email"];
        var mobileNumber = map["mobile_number"].toString();
        print("REcivedData = $userId\t$name\t$email\t$mobileNumber");
        await SharedPrefsHelper.saveUserData(userId: userId, name: name, email: email, mobileNumber: mobileNumber, jwt: jwt);
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(0)));
      }
    }
  }

  onSignUpPressed() async {
    // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context,_,__) => MobileVerificationScreen()));
    Navigator.push(context, MaterialPageRoute(builder: (context) => MobileVerificationScreen(), settings: RouteSettings(name: "MobileVerificationScreen")));
  }
}