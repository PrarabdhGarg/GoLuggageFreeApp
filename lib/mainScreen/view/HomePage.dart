import 'package:flutter/material.dart';
import 'package:go_luggage_free/mainScreen/view/MainScreen.dart';
import 'package:go_luggage_free/mainScreen/view/PastBookingsList.dart';
import 'package:go_luggage_free/mainScreen/view/StoreListingsPage.dart';
import 'package:go_luggage_free/profile/view/ProfileScreen.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageId = 0;
  bool isLoading = false;
  String displayMessage = "";
  Widget currentPage;
  Widget bottomNav;

  @override
  Widget build(BuildContext context) {
    print("Entered Lowest build");
    return displayMessage.isNotEmpty ? 
        showDialog(
          context: context
        ) : 
        Column(
          children: <Widget>[
            isLoading ? Center(child: CircularProgressIndicator(),) : Flexible(
              flex: 1,
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: getCurrentPage(),
              ),
            ),
            customBottomNav()
          ],
        );
  }

  Widget getCurrentPage() {
    if(currentPage == null) {
      if(currentPageId == 0) {
        currentPage = SizedBox.expand(child: StoreListingsPage(),);      
      } else {
        currentPage = SizedBox.expand(child: PastBookings(),);
      }
    }
    return currentPage;
  }

  Widget customBottomNav() {
    if(bottomNav == null) {
      bottomNav = SizedBox(
        width: double.infinity,
        height: 60,
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: SizedBox.expand(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    border: Border(
                      top: BorderSide(color: lightGrey)
                    )
                  ),
                  child: Center(
                    child: FlatButton(
                      child: Icon(Icons.home, color: this.currentPageId == 0 ? buttonColor : Colors.grey,),
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
                    color: Theme.of(context).backgroundColor,
                    border: Border(
                      top: BorderSide(color: lightGrey)
                    )
                  ),
                  child: Center(
                    child: FlatButton(
                      child: Icon(Icons.card_travel, color: this.currentPageId == 1 ? buttonColor : Colors.grey,),
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
    return bottomNav;
  }
}