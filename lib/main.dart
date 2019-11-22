import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:go_luggage_free/auth/login/view/LoginScreen.dart';
import 'package:go_luggage_free/shared/network/GraphQlProvider.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  FirebaseAnalytics _analytics = new FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    ValueNotifier<GraphQLClient> _graphQlClient = getClient();
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return GraphQLProvider(
      client: _graphQlClient,
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: _analytics),
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue,
            backgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: Colors.white,
              elevation: 0.0,
            ),
            fontFamily: 'Roboto',
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
          home: LoginPage()
        ),
      ),
    );
  }
}
