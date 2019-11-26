import 'package:flutter/material.dart';
import 'package:go_luggage_free/profile/view/ProfilePage.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:go_luggage_free/shared/utils/SharedPrefsHelper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: getUserId(),
      builder: (context, snapShot) {
        if(snapShot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        } else if (snapShot.connectionState == ConnectionState.done) {
          return ProfilePage(snapShot.data);
        } else {
          return Center(child: Text("Some Error Occoured. Try Again Later"),);
        }
      },
    );
  }

  Future<Map<String,String>> getUserId() async {
    String email = await SharedPrefsHelper.getUserEmail();
    String number = await SharedPrefsHelper.getUserNumber();
    String name = await SharedPrefsHelper.getUserName();
    return {
      "name": name,
      "email": email,
      "number": number
    };
  }
}