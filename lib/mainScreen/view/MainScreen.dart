import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_luggage_free/mainScreen/view/DrawerTile.dart';
import 'package:go_luggage_free/mainScreen/view/HomePage.dart';
import 'package:go_luggage_free/more/ContactUs.dart';
import 'package:go_luggage_free/more/FAQ.dart';
import 'package:go_luggage_free/profile/view/ProfileScreen.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:go_luggage_free/shared/utils/SharedPrefsHelper.dart';
import 'package:go_luggage_free/shared/views/ProfileWidget.dart';
import 'package:go_luggage_free/bookingForm/view/BookingFromScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  int currentPage;

  MainScreen(this.currentPage);

  @override
  MainScreenState createState() => MainScreenState(currentPage);
}

class MainScreenState extends State<MainScreen>  implements OnDrawerItemClickedCallback, CustomBottomNavPageChangeListener {
  int currentPage;
  int _selectedDrawerIndex = 0;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Widget activePage;
  String appBarTitle = "Home";
  List<MaterialPageRoute> _drawerRoutes;
 
  List<String> titles = ["Home", "Profile"];

  MainScreenState(this.currentPage) {
    enableFirebaseCloudMessagingListeners();
    
    _drawerRoutes = [
      MaterialPageRoute(builder: (context) => HomePage(this), settings: RouteSettings(name: "HomePage")),
      MaterialPageRoute(builder: (context) => ProfileScreen(), settings: RouteSettings(name: "Profile"))
    ];
  }

  Widget getPageForSelectedDrawerItem(int index) {
    print("Entered Page Selector");
    switch(index) {
      case 0: {
        print("Entered Case 0");
        activePage = HomePage(this);
        appBarTitle = titles[0];
        break;
      }
      case 1: {
        print("Entered Case 1");
        activePage = ProfileScreen();
        appBarTitle = titles[1];
        break;
      }
      default: {
        print("Entered Case default");
        activePage = activePage;
      }
    }
    return activePage;
  }

  @override
  Widget build(BuildContext context) {
    print("Entered Build");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(titles[_selectedDrawerIndex], style: Theme.of(context).textTheme.title, textAlign: TextAlign.start,),
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 8.0),
            child: Center(
              child: Text("Need Help?", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black),)
            )
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              child: Center(child: Text("Contact Us", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.blue[900]),)),
              onTap: () async {
                /* print("Entered onTap");
                String phoneNumber = "+917854866007";
                String url = "whatsapp://send?phone=$phoneNumber";
                await canLaunch(url) ? launch(url) : launch("tel://$phoneNumber"); */
                // await FlutterLaunch.launchWathsApp(phone: "8369276419", message: "");
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUs(), settings: RouteSettings(name: "Contact Us Page")));
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // ProfileWidget(),
            DrawerTile(text: "Home", onPressed: this, index: 0,),
            DrawerTile(text: "Profile", onPressed: this, index: 1,),
            DrawerTile(text: "FAQ", onPressed: this, index: 3,),
            DrawerTile(text: "Contact Us", onPressed: this, index: 2,),
            Container(
              alignment: Alignment.centerLeft,
              child: FlatButton(
                child: Text("Refer and Earn 25% Off", style: Theme.of(context).textTheme.headline.copyWith(color: buttonColor),),
                onPressed: () async {
                  String referralCode = await SharedPrefsHelper.getUserReferralCode();
                  final DynamicLinkParameters params = DynamicLinkParameters(
                    uriPrefix: "https://referrals.goluggagefree.com",
                    link: Uri.parse("https://goluggagefree.com?invitedBy=$referralCode"),
                    androidParameters: AndroidParameters(
                      packageName: "com.goluggagefree.goluggagefree",
                      minimumVersion: 9,
                      fallbackUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.goluggagefree.goluggagefree")
                    ),
                    googleAnalyticsParameters: GoogleAnalyticsParameters(
                      campaign: "user-referrals",
                      medium: "peer-to-peer",
                      source: "android-app"
                    )
                  );
                  final ShortDynamicLink shortLink = await params.buildShortLink();
                  final Uri link = shortLink.shortUrl;
                  String text = "Download the *GoLuggageFree App*. Find cloakrooms near you and enjoy the city luggage-free! Use my referral code: $referralCode to get 25% off on your first booking. ${link.toString()}";
                  /* prefix1.Intent()
                    ..setAction(prefix2.Action.ACTION_SEND_MULTIPLE)
                    ..setType('text/plain')
                    ..putExtra(Extra.EXTRA_TEXT, text)
                    ..startActivity().catchError((e) => print(e)); */
                  await canLaunch("whatsapp://send?text=$text") ? launch("whatsapp://send?text=$text") : print("Unable to launch whatsApp on phone");
                  Clipboard.setData(ClipboardData(text: text));
                  Fluttertoast.showToast(msg: "Copied Referral Code to clipboard");
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 8.0, top: (MediaQuery.of(context).size.height * 0.5)),
              child: RichText(
                text: TextSpan(
                    text: "Privacy Policy",
                    style: Theme.of(context).textTheme.body1.copyWith(color: buttonColor),
                    recognizer: TapGestureRecognizer()..onTap = () async {
                      await launch("https://goluggagefree.com/privacy");
                    }
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text("Vesion: 1.1.3"),
            )
          ],
        ),
      ),
      body: getPageForSelectedDrawerItem(_selectedDrawerIndex),
    );
  }

  void onDrawerItemClicked(int index) {
    /* print("Index = ${index}\n${_selectedDrawerIndex}");
    // This is to close the drawer as soon as the user makes a choice
    Navigator.of(context).pop();
    int previousIndex = _selectedDrawerIndex;
    setState(() {
     _selectedDrawerIndex = index; 
    });
    // If the user is currently not on the HomePage, and he doesn't want to go to the
    // home page, simply replace the current page  with the page he wants to visit
    // If the user wants to go to the HomePage, just pop the topmost widget from the stack
    // If the user is currently at the HomePage, and wants to go somewhere else, jsut add that page to the stack 
    if(previousIndex != index) {
      if(previousIndex != 0 && index != 0) {
        Navigator.pushReplacement(context, _drawerRoutes[index]); 
      } else if(index == 0) {
        Navigator.of(context).pop();
      } else {
        Navigator.push(context, _drawerRoutes[index]);
      }
    } */
    setState(() {
      if(index == 0 || index == 1) {
        _selectedDrawerIndex = index;
      }
    });
    Navigator.of(context).pop();
    if(index == 2) {
      print("Entered if condition after pop");
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUs(), settings: RouteSettings(name: "Contact Us Page")));
    }
    if(index == 3) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => FAQ(), settings: RouteSettings(name: "FAQ Page")));
    }
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
  
  @override
  void onBottomNavPageChanged(int index) {
    if(index == 0) {
      setState(() {
        appBarTitle = "Home";
      });
    }
    else {
      setState(() {
        appBarTitle = "Bookings";
      });
    }
  }
}