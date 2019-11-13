import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_luggage_free/mainScreen/model/StorrageSpacesDAO.dart';
import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/storeInfoScreen/view/StoreInfoScreen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';

class StoreListingsPage extends StatefulWidget {
  @override
  _StoreListingsPageState createState() => _StoreListingsPageState();
}

class _StoreListingsPageState extends State<StoreListingsPage> {
  String getStrorageSpaces = """
  query {
      storageSpaces {
      _id
      name
      ownerName
      storeImages
      hasCCTV
      address
      longAddress
      rating
      costPerHour
      timings
      ownerImage
      area {
        _id
        name
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
          List<StorageSpace> storageSpaces = StorageSpaces.fronMap(result.data['storageSpaces']).list;
          StorageSpacesDAO.insertStorageSpaces(storageSpaces);
          return ListView.builder(
            itemCount: storageSpaces.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: StorageWidget(storageSpaces[index]),
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoreInfoScreen(storageSpaces[index].id)));
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget StorageWidget(StorageSpace storageSpace) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, top: 6.0, right: 8.0, bottom: 6.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: HexColor("#DDDDDD"),
            spreadRadius: 1.0,
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              child: Image.network(
                imageBaseUrl + storageSpace.storeImages[0],
                fit: BoxFit.scaleDown,
                gaplessPlayback: true,                
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(storageSpace.name, style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    child: Text(storageSpace.displayLocation,),
                  ),
                  Container(height: 20,),
                  Container(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: RatingBarIndicator(
                        rating: storageSpace.rating,
                        itemCount: 5,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Icon(Icons.videocam, color: storageSpace.hasCCTV ? Colors.green: Colors.transparent),
                Container(child: Text("CCTV", style: TextStyle(fontSize: 8,color: storageSpace.hasCCTV ? Colors.black : Colors.transparent),),),
                Container(height: 15,),
                Container(child: Text("\u20B9${storageSpace.costPerHour*24}", style: TextStyle(fontWeight: FontWeight.bold),),),
                Container(child: Text("Per Day", style: TextStyle(fontSize: 12),),),
              ],
            ),
          )
        ],
      )
    );
  }
}