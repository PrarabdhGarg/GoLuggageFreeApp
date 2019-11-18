import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:go_luggage_free/auth/login/view/LoginScreen.dart';
import 'package:go_luggage_free/shared/network/GraphQlProvider.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<GraphQLClient> _graphQlClient = getClient();
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return GraphQLProvider(
      client: _graphQlClient,
      child: CacheProvider(
        child: MaterialApp(
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
              title: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold,),
              button: TextStyle(color: Colors.white,),
              overline: TextStyle(color: buttonColor, fontSize: 10.0),
              headline: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold), 
              body1: TextStyle(color: Colors.grey, fontSize: 12)
            )
          ),
          home: LoginPage()
        ),
      ),
    );
  }
}
