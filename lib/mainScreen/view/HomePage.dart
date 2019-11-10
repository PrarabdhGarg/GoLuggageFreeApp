import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageId = 0;
  bool isLoading = false;
  String displayMessage = "";

  @override
  Widget build(BuildContext context) {
    return displayMessage.isNotEmpty ? 
        showDialog(
          context: context
        ) : 
        Column(
          children: <Widget>[
            isLoading ? Center(child: CircularProgressIndicator(),) : Flexible(
              flex: 1,
              child: getCurrentPage(),
            ),
            customBottomNav()
          ],
        );
  }

  Widget getCurrentPage() {
    if(currentPageId == 0) {
      return SizedBox.expand(child: Text("Home Page"),);      
    } else {
      return SizedBox.expand(child: Text("Bookings"),);
    }
  }

  Widget customBottomNav() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: SizedBox.expand(
              child: Container(
                color: Colors.blue[900],
                child: Center(
                  child: FlatButton(
                    child: Icon(Icons.home, color: Colors.white,),
                    onPressed: () {
                      setState(() {
                       currentPageId = 0; 
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox.expand(
              child: Container(
                color: Colors.blue[900],
                child: Center(
                  child: FlatButton(
                    child: Icon(Icons.print, color: Colors.white,),
                    onPressed: () {
                      setState(() {
                       currentPageId = 1; 
                      });
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}