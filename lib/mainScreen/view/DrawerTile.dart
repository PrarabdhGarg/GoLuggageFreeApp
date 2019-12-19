import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  String text;
  int index;
  OnDrawerItemClickedCallback onPressed;

  DrawerTile({@required this.text, this.onPressed, @required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed.onDrawerItemClicked(index);
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: getDrawerIcon(text),          
              ),
            ),
            Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  text,
                  textAlign: TextAlign.left,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getDrawerIcon(String text) {
    switch(text) {
      case "Home": {
        return Icon(Icons.home);
      }
      case "Profile": {
        return Icon(Icons.person);
      }
      case "FAQ": {
        return Icon(Icons.question_answer);
      }
      case "Contact Us": {
        return Icon(Icons.info);
      }
      default: {
        return Container();
      }
    }
  }
}

abstract class OnDrawerItemClickedCallback {
  void onDrawerItemClicked(int index);
}