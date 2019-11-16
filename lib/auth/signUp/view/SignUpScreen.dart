import 'package:flutter/material.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/mainScreen/view/MainScreen.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController nameController = new TextEditingController(text: "");
  TextEditingController emailController = new TextEditingController(text: "");
  TextEditingController passwordController = new TextEditingController(text: "");
  TextEditingController passwordConfirmationController = new TextEditingController(text: "");

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
                child: CustomWidgets.customEditText(controller: passwordController, context: context, label: "Password", hint: "Please Select a password", validator: Validators.passwordValidator),
              ),
              Flexible(
                flex: 1,
                child: CustomWidgets.customEditText(context: context, controller: passwordConfirmationController, hint: "Please confirm your password", label: "Confirm Password", validator: Validators.otpValidator),
              ),
              CustomWidgets.customLoginButton(text: "Sign Up", onPressed: onSignUpPressed)
            ],
          ),
        ),
      ),
    );
  }

  onSignUpPressed() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen(0)));
  }
}