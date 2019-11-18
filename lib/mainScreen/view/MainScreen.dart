import 'package:flutter/material.dart';
import 'package:go_luggage_free/mainScreen/view/DrawerTile.dart';
import 'package:go_luggage_free/mainScreen/view/HomePage.dart';
import 'package:go_luggage_free/mainScreen/view/PastBookingsList.dart';

class MainScreen extends StatefulWidget {
  int currentPage;

  MainScreen(this.currentPage);

  @override
  _MainScreenState createState() => _MainScreenState(currentPage);
}

class _MainScreenState extends State<MainScreen>  implements OnDrawerItemClickedCallback {
  int currentPage;
  int _selectedDrawerIndex = 0;

  _MainScreenState(this.currentPage);

  List<Widget> _drawerWidgets;

  Widget getPageForSelectedDrawerItem(int index) {
    print("Entered Page Selector");
    switch(index) {
      case 0: {
        print("Entered Case 0");
        return HomePage();
      }
      case 1: {
        print("Entered Case 1");
        return PastBookings();
      }
      default: {
        print("Entered Case default");
        return Container(child: Text("Error!!!"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Entered Build");
    _selectedDrawerIndex = currentPage;
    _drawerWidgets = [
      
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: Theme.of(context).textTheme.title, textAlign: TextAlign.start,),
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
}