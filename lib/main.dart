import 'package:flutter/material.dart';
import 'package:go_luggage_free/auth/login/view/LoginScreen.dart';
import 'package:go_luggage_free/shared/network/GraphQlProvider.dart';
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
          ),
          home: LoginPage()
        ),
      ),
    );
  }
}
