import 'package:flutter/material.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';

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
        title: Text("Sign Up"),
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
                  child: Image.network("https://goluggagefree.com/image/hero-img-blue.png"),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Please Enter Your Name'
                    ),
                    controller: nameController,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Please Enter Your E-mail id'
                    ),
                    controller: emailController,
                    validator: Utils.emailValidator,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Please Select a Password'
                    ),
                    controller: passwordController,
                    validator: Utils.passwordValidator,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    enabled: passwordController.text.toString().isNotEmpty,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Please Confirm your password'
                    ),
                    controller: passwordConfirmationController,
                    validator: Utils.passwordValidator,
                  ),
                ),
              ),
              CustomWidgets.customLoginButton(text: "Sign Up", onPressed: onSignUpPressed)
            ],
          ),
        ),
      ),
    );
  }

  onSignUpPressed() {

  }
}