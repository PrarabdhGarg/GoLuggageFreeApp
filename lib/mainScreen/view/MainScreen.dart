import 'package:flutter/material.dart';
import 'package:go_luggage_free/mainScreen/view/DrawerTile.dart';
import 'package:go_luggage_free/mainScreen/view/HomePage.dart';

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
      DrawerTile(text: "Home", onPressed: this, index: 0,),
      DrawerTile(text: "Profile", onPressed: this, index: 1,),
      DrawerTile(text: "FAQ", onPressed: this, index: 2,),
      DrawerTile(text: "Contact", onPressed: this, index: 3,),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("GoLuggageFree"),
      ),
      drawer: Drawer(
        child: Column(
          children: _drawerWidgets,
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