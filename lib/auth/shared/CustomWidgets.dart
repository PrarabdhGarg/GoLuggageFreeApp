import 'package:flutter/material.dart';
import 'package:go_luggage_free/auth/shared/Utils.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';

class CustomWidgets {
  static Widget customLoginButton({String text, Function onPressed}) {
    return Flexible(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.all(Radius.circular(25.0))
        ),
        child: FlatButton(
          child: SizedBox(
            width: 200.0,
            height: 50.0,
            child: Center(child: Text(text, 
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
              )
            ),
         ),
          color: Colors.transparent,
          onPressed: onPressed,
        ),
      ),
    );
  }

  static Widget customEditText({@required BuildContext context, @required TextEditingController controller, @required String label, @required String hint, @required Function validator, TextInputType inputType = TextInputType.text, bool obscureText = false}) {
    return Container(
      margin: EdgeInsets.only(right: 30.0, left: 30.0),
      child: TextFormField(
        keyboardType: inputType,
        autovalidate: true,
        cursorColor: cursorColor,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: cursorColor
            )
          ),
          hintText: hint,
          labelStyle: Theme.of(context).textTheme.overline
        ),
        controller: controller,
        validator: validator,
      ),
    );
  }
}