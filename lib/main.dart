import 'package:flutter/material.dart';
import 'package:go_luggage_free/auth/login/view/LoginScreen.dart';
import 'package:go_luggage_free/shared/network/GraphQlProvider.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart' as prefix0;
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<GraphQLClient> _graphQlClient = getClient();

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
            fontFamily: 'Roboto',
            buttonColor: prefix0.buttonColor,
            textTheme: TextTheme(
              title: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.white),
              overline: TextStyle(color: prefix0.buttonColor, fontFamily: 'Roberto', fontSize: 10.0)
            )
          ),
          home: LoginPage()
        ),
      ),
    );
  }
}
