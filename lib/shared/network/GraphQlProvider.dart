import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

ValueNotifier<GraphQLClient> getClient() {
  final HttpLink httpLink = HttpLink(
    uri: "https://luglog.herokuapp.com/graphql"
  );

  /* final AuthLink authLink = AuthLink(
     getToken: () async => "Bearer + Token"
  ); */

  final Link link = httpLink;

  ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
    link: link,
    cache: InMemoryCache()
  ));
  return client;
}