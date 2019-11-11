import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StoreListingsPage extends StatefulWidget {
  @override
  _StoreListingsPageState createState() => _StoreListingsPageState();
}

class _StoreListingsPageState extends State<StoreListingsPage> {
  String getStrorageSpaces = """
  query {
    areas {
      _id
      storageSpaces {
        _id
        name
        location
      }
    }
  }
  """;
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Query(
        options: QueryOptions(
          document: getStrorageSpaces,
        ),
        builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
          if(result.errors != null) {
            print("Error occoured = ${result.errors.toList().toString()}");
            return Center(child: Text("Error in loading Data. Please try after some time"),);
          }
          if(result.loading) {
            print("Loading the result");
            return Center(child: CircularProgressIndicator(),);
          }
          print("Result = ${result.data.toString()}");
          // return Container(child: Text("Data fetched successfully"),);
          var repositories = result.data['areas'];
          return ListView.builder(
            itemCount: repositories.length,
            itemBuilder: (context, index) {
              return Text(
                repositories[index]['_id'].toString()
              );
            },
          );
        },
      ),
    );
  }
}