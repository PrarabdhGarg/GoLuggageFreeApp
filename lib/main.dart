import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:go_luggage_free/auth/login/view/LoginScreen.dart';
import 'package:go_luggage_free/shared/network/GraphQlProvider.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/SharedPrefsHelper.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:statusbar/statusbar.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white, //bottom bar color
      )
  );
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(new MyApp()));
} 

class MyApp extends StatelessWidget {

  MyApp() {
    checkForDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<GraphQLClient> _graphQlClient = getClient();
    return GraphQLProvider(
      client: _graphQlClient,
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue,
            backgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: Colors.white,
              elevation: 0.0,
            ),
            buttonColor: buttonColor,
            textTheme: TextTheme(
              title: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
              button: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
              overline: TextStyle(color: buttonColor, fontSize: 10.0, fontFamily: 'Roboto'),
              headline: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Roboto'), 
              body1: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Roboto'),
              body2: TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Roboto'),
            )
          ),
          home: LoginPage(),
        ),
      ),
    );
  }

  Future<Null> checkForDynamicLinks() async {
    print("Entered dynamic links handler");
    final PendingDynamicLinkData pendingData = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = pendingData?.link;
    await handleDeepLink(deepLink);
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData pendingData) async {
        final deepLink = pendingData?.link;
        await handleDeepLink(deepLink);
      },
      onError: (OnLinkErrorException e) async {

      }
    );
  }

  Future<Null> handleDeepLink(Uri deepLink) async {
    if(deepLink != null) {
      print("Recived Dynamic link = ${deepLink.toString()}");
      if(deepLink.queryParameters.containsKey("invitedBy")) {
        String invitedBy = deepLink.queryParameters["invitedBy"];
        print("Invitation Recived from id = $invitedBy");
        await SharedPrefsHelper.addInvidedById(invitedBy);
      } else {
        print("Query Method not found");
      }
    }
  }
}
