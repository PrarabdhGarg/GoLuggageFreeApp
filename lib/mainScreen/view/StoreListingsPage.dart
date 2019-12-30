import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_luggage_free/mainScreen/model/StorrageSpacesDAO.dart';
import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/CustomAnalyticsHelper.dart';
import 'package:go_luggage_free/storeInfoScreen/view/StoreInfoScreen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:provider/provider.dart';

class StoreListingsPage extends StatefulWidget {
  @override
  _StoreListingsPageState createState() => _StoreListingsPageState();
}

class _StoreListingsPageState extends State<StoreListingsPage> {
  List<StorageSpace> storageSpaces;
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
      location
      rating
      costPerHour
      timings
      ownerDetail
      open
      ownerImage
      numOfBookings
      area {
        _id
        name
      }
    }
  }
  """;
  @override
  Widget build(BuildContext context) {
    print("Entered Build For Store Listings");
    if(storageSpaces == null) {
      print("Entered if");
      return buildPage();
    } 
    return buildList(storageSpaces);
  }

  Widget buildPage() {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border(
            top: BorderSide(color: lightGrey,)
          )
        ),
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
            storageSpaces = StorageSpaces.fronMap(result.data['storageSpaces']).list;
            StorageSpacesDAO.insertStorageSpaces(storageSpaces);
            return buildList(storageSpaces);
          },
        ),
      ),
    );
  }

  Widget buildList(List<StorageSpace> storageSpaces) {
    print("Recived List = ${storageSpaces.toList()}");
    return ListView.builder(
      itemCount: storageSpaces.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: StorageWidget(storageSpaces[index], index),
          onTap: () async {
            // Navigator.of(context).push(PageRouteBuilder(opaque: false, maintainState: true, pageBuilder: (BuildContext context,_,__) => StoreInfoScreen(storageSpaces[index].id)));
            FirebaseAnalytics _analytics = CustomAnalyticsHelper.getAnalyticsInstance();
            await _analytics.logViewItem(
              itemId: storageSpaces[index].id,
              itemName: storageSpaces[index].name,
              startDate: DateTime.now().toString(),
              itemCategory: "Storage Space"
            );
            Navigator.push(context, MaterialPageRoute(builder: (context) => StoreInfoScreen(storageSpaces[index].id), maintainState: false));
          },
        );
      },
    );
  }

  Widget StorageWidget(StorageSpace storageSpace, int index) {
    String imageUrl = "";
    if(storageSpace.storeImages.isNotEmpty) {
      imageUrl = imageBaseUrl + storageSpace.storeImages[0];
    }
    return Container(
      margin: EdgeInsets.only(left: 8.0, top: 6.0, right: 8.0, bottom: 6.0),
      height: 120,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Theme.of(context).backgroundColor,
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
              margin: EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: "storeImage${storageSpaces[index].id}",
                    child: AspectRatio(
                      aspectRatio: 1/1.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1/1.3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.fill,
                        color: Color.fromARGB(80, 00, 120, 255),
                        gaplessPlayback: true,                
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1/1.3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Opacity(
                        opacity: 0.90,
                        child: selectOverlayIcon(index)
                      ),
                    ),
                  ),
                ],
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
                    child: Text(storageSpace.displayLocation, style: Theme.of(context).textTheme.headline),
                  ),
                  Container(
                    child: Text(storageSpace.name, style: Theme.of(context).textTheme.body1,),
                  ),
                  Container(height: 25,),
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
                        itemSize: 15,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 8.0),
            child: Column(
              children: <Widget>[
                Container(height: 25,),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(storageSpace.hasCCTV ? "assets/images/cctv.png" : "assets/images/no_cctv.png"),
                      fit: BoxFit.scaleDown
                    )
                  ),
                ),
                Container(child: Text("CCTV", style: TextStyle(fontSize: 8,color: storageSpace.hasCCTV ? Colors.black : Colors.transparent),),),
                Container(height: 10,),
                Container(child: Text("\u20B9${(storageSpace.costPerHour*24).round()}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),),
                // Container(child: Text("Per Day", style: TextStyle(fontSize: 10),),),
              ],
            ),
          )
        ],
      )
    );
  }

  Widget selectOverlayIcon(int index) {
    if(index == 1 || index == 2 || index == 3) {
      return Icon(Icons.train, color: Colors.white,size: 34.0,);
    } else if(index == 4) {
      return Icon(Icons.local_airport, color: Colors.white,size: 34.0,);
    } else {
      return Icon(Icons.store, color: Colors.white,size: 34.0,);
    }
  }
}