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

  List<MaterialPageRoute> _drawerRoutes = [
    MaterialPageRoute(builder: (context) => HomePage(), settings: RouteSettings(name: "HomePage")),
    MaterialPageRoute(builder: (context) => ProfileScreen(), settings: RouteSettings(name: "Profile"))
  ];

  /* Widget getPageForSelectedDrawerItem(int index) {
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
  } */

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
      body: HomePage(),
    );
  }

  void onDrawerItemClicked(int index) {
    // This is to close the drawer as soon as the user makes a choice
    Navigator.of(context).pop();

    // If the user is currently not on the HomePage, and he doesn't want to go to the
    // home page, simply replace the current page  with the page he wants to visit
    // If the user wants to go to the HomePage, just pop the topmost widget from the stack
    // If the user is currently at the HomePage, and wants to go somewhere else, jsut add that page to the stack 
    if(_selectedDrawerIndex != index) {
      if(_selectedDrawerIndex != 0 && index != 0) {
        Navigator.pushReplacement(context, _drawerRoutes[index]); 
      } else if(index == 0) {
        Navigator.of(context).pop();
      } else {
        Navigator.push(context, _drawerRoutes[index]);
      }
    }
    setState(() {
     _selectedDrawerIndex = index; 
    });
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