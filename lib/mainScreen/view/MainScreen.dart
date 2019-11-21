import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_luggage_free/mainScreen/view/DrawerTile.dart';
import 'package:go_luggage_free/mainScreen/view/HomePage.dart';
import 'package:go_luggage_free/mainScreen/view/PastBookingsList.dart';
import 'package:go_luggage_free/profile/view/ProfileScreen.dart';

class MainScreen extends StatefulWidget {
  int currentPage;

  MainScreen(this.currentPage);

  @override
  _MainScreenState createState() => _MainScreenState(currentPage);
}

class _MainScreenState extends State<MainScreen>  implements OnDrawerItemClickedCallback {
  int currentPage;
  int _selectedDrawerIndex = 0;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Widget activePage;
  String title = "Home";

  _MainScreenState(this.currentPage) {
    enableFirebaseCloudMessagingListeners();
  }

  List<Widget> _drawerWidgets;

  Widget getPageForSelectedDrawerItem(int index) {
    print("Entered Page Selector");
    switch(index) {
      case 0: {
        print("Entered Case 0");
        if(activePage == null || !(activePage is HomePage)) {
          activePage = HomePage();
          title = "Home";
        }
        break;
      }
      case 1: {
        print("Entered Case 1");
        if(activePage == null || !(activePage is ProfileScreen)) {
          activePage = ProfileScreen();
          title = "Profile";
        }
        break;
      }
      default: {
        print("Entered Case default");
        activePage = Container(child: Text("Error!!!"));
      }
    }
    return activePage;
  }

  @override
  Widget build(BuildContext context) {
    print("Entered Build");
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.title, textAlign: TextAlign.start,),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerTile(text: "Home", onPressed: this, index: 0,),
            DrawerTile(text: "Profile", onPressed: this, index: 1,),
            DrawerTile(text: "FAQ", onPressed: this, index: 2,),
            DrawerTile(text: "Contact", onPressed: this, index: 3,),
          ],
        ),
      ),
      body: getPageForSelectedDrawerItem(_selectedDrawerIndex),
    );
  }

  void onDrawerItemClicked(int index) {
    setState(() {
     _selectedDrawerIndex = index; 
    });
    Navigator.of(context).pop();
  }

  void enableFirebaseCloudMessagingListeners() {
    // TODO Add permissions in IOS for notifications
    _firebaseMessaging.getToken().then((token) {
      print("Recived Firebase Token = ${token.toString()}");
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }
}