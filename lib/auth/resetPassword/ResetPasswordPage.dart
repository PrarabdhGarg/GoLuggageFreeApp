import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_luggage_free/auth/shared/CustomWidgets.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorChecker.dart';
import 'package:go_luggage_free/shared/network/errors/NetworkErrorListener.dart';
import 'package:go_luggage_free/shared/utils/SharedPrefsHelper.dart';
import 'package:go_luggage_free/shared/views/StandardAlertBox.dart';
import 'package:http/http.dart' as http;
import 'package:go_luggage_free/shared/utils/Constants.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> implements NetworkErrorListener {
  bool isLoading;
  TextEditingController _otpConreoller = new TextEditingController(text: "");
  TextEditingController _newPasswordController = new TextEditingController(text: "");
  TextEditingController _confirmPasswordController = new TextEditingController(text: "");
  GlobalKey<FormState> _formKey = new GlobalKey();

  @override
  void initState() {
    this.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
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
                  child: CustomWidgets.customEditText(controller: _otpConreoller, context: context, hint: "Please Enter OTP", label: "OTP", validator: Validators.otpValidator, inputType: TextInputType.phone),
                ),
                Flexible(
                  flex: 1,
                  child: CustomWidgets.customEditText(context: context, controller: _newPasswordController, hint: "Please Enter New Password", label: "New Password", validator: Validators.passwordValidator, obscureText: true),
                ),
                Flexible(
                  flex: 1,
                  child: CustomWidgets.customEditText(context: context, controller: _confirmPasswordController, hint: "Please Confirm New Password", label: "Confirm Password", validator: Validators.passwordValidator, obscureText: true),
                ),
                Container(height: 24,),
                CustomWidgets.customLoginButton(text: "Reset Password", onPressed: onResetPasswordPressed),
              ],
            ),
          ),
      ),
    );
  }

  onResetPasswordPressed() async {
    if(_formKey.currentState.validate()) {
      if(_newPasswordController.text == _confirmPasswordController.text) {
        setState(() {
          this.isLoading = true;
        });
        String mobileNumber = await SharedPrefsHelper.getUserNumber();
        var response = await http.post(resetPassword, body: {
          "number": mobileNumber,
          "otp": _otpConreoller.text,
          "password": _newPasswordController.text
        }, headers: {"X-Version": versionCodeHeader});
        print("Response Status = ${response.statusCode}");
        print("Response Body = ${response.body}");
        NetworkErrorChecker(networkErrorListener: this, respoonseBody: response.body);
        if(response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            this.isLoading = false;
          });
          onToastMessageRecived(message: "Password Updated Sucessfully");
          Navigator.pop(context);
        }
      } else {
        onToastMessageRecived(message: "New Password and confirmation Password must match");
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