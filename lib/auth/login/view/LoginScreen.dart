import 'package:flutter/material.dart';
import 'package:go_luggage_free/auth/mobileVerification/view/MobileVerificationScreen.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(NetworkImage("https://goluggagefree.com/static/media/hero-img-blue.d5bcd689.png"), context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        leading: Container(),
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
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return Center(child: CircularProgressIndicator(),);
    } else {
      return SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(32),
                    child: Image.network("https://goluggagefree.com/static/media/hero-img-blue.d5bcd689.png"),
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
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Please Enter Password',
                      ),
                      obscureText: true,
                      controller: passwordController,
                      validator: Utils.passwordValidator,
                    ),
                  ),
                ),
                CustomWidgets.customLoginButton(text: "LOGIN", onPressed: onLoginPressesed),
                Flexible(
                  flex: 1,
                  child: Center(child: Text("OR", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),),
                ),
                CustomWidgets.customLoginButton(text: "CREATE NEW ACCOUNT", onPressed: onSignUpPressed),
              ],
            ),
          ),
        ),
      );
    }
  }

  onLoginPressesed() {
    if(_formKey.currentState.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login"),
            content: Text("Number = ${phoneController.text}\nPassword = ${passwordController.text}"),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.all(4.0),
                child: FlatButton(
                  child: Text("OK"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        }
      );
    }
  }

  onSignUpPressed() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MobileVerificationScreen()));
  }
}