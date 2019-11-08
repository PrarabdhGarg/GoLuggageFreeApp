import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        leading: Container(),
      ),
      body: loginPage(context),
    );
  }

  Widget loginPage(BuildContext context) {
    String _phone = "";
    String _password = "";
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                    // labelText: 'Phone Number',
                    hintText: 'Please Enter Phone Number'
                  ),
                  validator: (phone) {
                    // TODOAdd a suitable validator after discussions
                  },
                  onSaved: (value) {
                    _phone = value;
                  },
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
                    // labelText: 'Password',
                    hintText: 'Please Enter Password'
                  ),
                  validator: (password) {
                    // TODOAdd a suitable validator after discussions
                  },
                  onSaved: (value) {
                    _password = value;
                  },
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                ),
                child: FlatButton(
                  child: SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: Center(child: Text("LOGIN", 
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      )
                    ),
                  ),
                  color: Colors.transparent,
                  onPressed: () {
                    // TODOadd login funtionality to the login button
                  },
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Center(child: Text("OR", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),),
            ),
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                ),
                child: FlatButton(
                  child: SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: Center(child: Text("Create A New Account", 
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      )
                    ),
                  ),
                  color: Colors.transparent,
                  onPressed: () {
                    // TODOadd login funtionality to the login button
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}