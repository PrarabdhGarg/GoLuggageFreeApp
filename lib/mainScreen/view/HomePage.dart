import 'package:flutter/material.dart';
import 'package:go_luggage_free/mainScreen/view/PastBookingsList.dart';
import 'package:go_luggage_free/mainScreen/view/StoreListingsPage.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';

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
              child: Container(
                color: Colors.white,
                child: getCurrentPage(),
              ),
            ),
            customBottomNav()
          ],
        );
  }

  Widget getCurrentPage() {
    if(currentPageId == 0) {
      return SizedBox.expand(child: StoreListingsPage(),);      
    } else {
      return SizedBox.expand(child: PastBookings(),);
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: HexColor("#DDDDDD"),
                      spreadRadius: 1.0,
                      blurRadius: 1.0
                    )
                  ]
                ),
                // color: Colors.white,
                child: Center(
                  child: FlatButton(
                    child: Icon(Icons.home, color: Colors.blue[900],),
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: HexColor("#DDDDDD"),
                      spreadRadius: 1.0,
                      blurRadius: 1.0,
                    )
                  ]
                ),
                // color: Colors.white,
                child: Center(
                  child: FlatButton(
                    child: Icon(Icons.print, color: Colors.blue[900],),
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