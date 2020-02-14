import 'dart:async';
import 'dart:convert';
import 'dart:io';  
import 'dart:ui';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_luggage_free/mainScreen/model/StorrageSpacesDAO.dart';
import 'package:go_luggage_free/mainScreen/model/SuggestedLocation.dart';
import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:go_luggage_free/shared/utils/CustomAnalyticsHelper.dart';
import 'package:go_luggage_free/shared/utils/SharedPrefsHelper.dart';
import 'package:go_luggage_free/storeInfoScreen/view/StoreInfoScreen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:http/http.dart' as http;

class StoreListingsPage extends StatefulWidget {
  @override
  _StoreListingsPageState createState() => _StoreListingsPageState();
}

class _StoreListingsPageState extends State<StoreListingsPage> {
  List<StorageSpace> storageSpaces;
  List<SuggestedLocation> searchSuggestions = List();
  GlobalKey<AutoCompleteTextFieldState<SuggestedLocation>> searchKey = GlobalKey();
  bool isLoading;
  Timer _debounce;
  String latitude = "", longitude = "";

  String getStrorageSpacesWithParams = """
  query getStorageSpaces(\$latitude: String!, \$longitude: String!) {
      storageSpaces (latitude: \$latitude, longitude: \$longitude) {
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
      type
      ownerImage
      numOfBookings
      area {
        _id
        name
      }
    }
  }
  """;

  String getStorageSpaces = """
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
      type
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
  void initState() {
    isLoading = true;
    getStorageSpaceNearCoordinates(defaultLocation: true);
  }

  _onSearchQueryChanged(String searchText) {
    if(_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      print("Fetching new data");
      fetchUpdatedSuggestions(searchText);
    });
  }

  Future<Null> fetchUpdatedSuggestions(String searchQuery) async {
    String jwt = await SharedPrefsHelper.getJWT();
    String mmiToken = await SharedPrefsHelper.getMapMyIndiaAccessToken();
    if(mmiToken == "") {
      var response = await http.get(getMapMyIndiaToken, headers: {HttpHeaders.authorizationHeader: "$jwt"});
      print("Result code = ${response.statusCode}");
      print("${response.body}");
      if(response.statusCode != 200) 
        return;
      String token = jsonDecode(response.body.toString())["accessToken"].toString();
      print("AccessToken Recived = $token");
      await SharedPrefsHelper.setMapMyIndiaAccessToken(token);
    }
    var result = await http.get("https://atlas.mapmyindia.com/api/places/search/json?query="+searchQuery, headers: {HttpHeaders.authorizationHeader: "bearer $mmiToken"});
    print("Result code = ${result.statusCode}");
    print("${result.body}");
    if(result.statusCode >= 200 && result.statusCode < 300) {
      print("Suggestions call successful with body = ${result.body}");
      var map = jsonDecode(result.body.toString());
      List<dynamic> places = map["suggestedLocations"];
      if(places?.isNotEmpty ?? false) {
        searchKey.currentState.suggestions = [];
        for(var place in places) {
          print("Place = $place");
          searchKey.currentState.addSuggestion(SuggestedLocation.fromJson(place));
        }
        print("New suggestionsList = $searchSuggestions");
      }
    }
  }
  
  Future<Null> getStorageSpaceNearCoordinates({@required bool defaultLocation, double latitude, double longitude}) async {
    print("Entered getNearLocation");
    setState(() {
      isLoading = true;
    });
    if(defaultLocation) {
      try {
        print("Entering try");
        var geolocator = Geolocator()..forceAndroidLocationManager;
        var currentLocation = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
        print("Loction = $latitude \n $longitude");
      } on PlatformException catch(e) {
        print(e.toString());
        setState(() {
          
        });
      } catch(e) {
        print(e.toString());
      }
    } else {
      print("Entered else statement");
      setState(() {
        this.latitude = latitude.toString();
        this.longitude = longitude.toString();
      });
    }
    print("Inside request to server with lat = $latitude and longitude = $longitude");
  }

  @override
  Widget build(BuildContext context) {
    print("Entered Build For Store Listings");
    return WillPopScope(
      onWillPop: () async {
        print("Entered on will pop scope");
        if(latitude != "" || longitude != "") {
          setState(() {
            this.latitude = "";
            this.longitude = "";
          });
          return false;
        } else {
          return true;
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0, left: 16.0, top: 4.0, bottom: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: HexColor("#e4e6e6")
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child:Container(
                    margin: EdgeInsets.only(right: 16.0, left: 8.0),
                    child: AutoCompleteTextField<SuggestedLocation> (
                      key: searchKey,
                      suggestions: searchSuggestions,
                      clearOnSubmit: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: HexColor("#b4b2b2"),
                        ),
                        border: InputBorder.none,
                        hintText: "Search for nearby locations",
                        hintStyle: Theme.of(context).textTheme.body1.copyWith(color: HexColor("#8e8b8b"), fontSize: 14)
                      ),
                      itemFilter: (SuggestedLocation item, String query) {
                        return true;
                      },
                      itemSubmitted: (SuggestedLocation item) {
                        print("Entered Item Submittted with ${item.lattitude} , ${item.longitude}");
                        searchKey.currentState.textField.controller.text = item.name;
                        getStorageSpaceNearCoordinates(defaultLocation: false, latitude: item.lattitude, longitude: item.longitude);
                      },
                      itemBuilder: (BuildContext context, SuggestedLocation item) => Container(
                        padding: EdgeInsets.all(4.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Text(item.name, style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black),)
                        ),
                      ),
                      textChanged: (String text) {
                        print("Entered on Text changed");
                        _onSearchQueryChanged(text);
                      },
                    ),
                  )
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: buildPage(),
          )
        ],
      ),
    );
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
            document: latitude == "" && longitude == "" ? getStorageSpaces : getStrorageSpacesWithParams,
            fetchPolicy: FetchPolicy.cacheFirst,
            variables: latitude == "" && longitude == "" ? { } : {
              'latitude': latitude,
              'longitude': longitude
            }
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
        return Stack(
          children: <Widget>[
            GestureDetector(
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
            ),
            /* Transform.rotate(
              angle: -(pi/4.0),
              origin: Offset(0, 18),
              child: Container(
                width: 73,
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(24.0), topLeft: Radius.circular(24.0)),
                  color: Colors.blue
                ),
                padding: EdgeInsets.only(left: 4.0, top: 2.0),
                margin: EdgeInsets.only(top: 16.0),
                child: Center(child: Text("${storageSpaces[index].numOfBookings.toString()} Bookings", style: TextStyle(color: Colors.white, fontSize: 10),)),
              ),
            ), */
          ],
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
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 2.0, left: 4.0, right: 4.0),
                            child: Text(storageSpace.rating.toString(), style: Theme.of(context).textTheme.body1,),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 4.0),
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.star, color: HexColor("#ffc107"), size: 20,),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 12.0, right: 4.0),
                            child: Center(child: Text("${storageSpace.numOfBookings} Bookings",)),
                          )
                        ],
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
                Container(height: 15,),
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
                Container(height: 20,),
                Container(child: Text("\u20B9${(storageSpace.costPerHour*24).round()}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, fontFamily: 'Roboto'),),),
                // Container(child: Text("Per Day", style: TextStyle(fontSize: 10),),),
              ],
            ),
          )
        ],
      )
    );
  }

  Widget selectOverlayIcon(int index) {
    switch(storageSpaces[index].type) {
      case "Railway Station": 
        return Icon(Icons.train, color: Colors.white,size: 34.0,);
      case "Airport":
        return Icon(Icons.local_airport, color: Colors.white,size: 34.0,);
      case "Hotel":
        return Icon(Icons.hotel, color: Colors.white,size: 34.0,);
      case "Store":
        return Icon(Icons.store, color: Colors.white,size: 34.0,);
      default:
        return Icon(Icons.store, color: Colors.white,size: 34.0,);
    }
  }

  Future<List<SuggestedLocation>> getSuggestedLocations(String searchText) async {
    print("Entered fun 1");
    if(searchText == null || searchText == "")
      searchText = "";
    List<SuggestedLocation> suggestionsList = List();
    var response = await http.get(getMapMyIndiaToken);
    if(response.statusCode == 200) {
      String token = jsonDecode(response.body.toString())["accessToken"].toString();
      print("AccessToken Recived = $token");
      var result = await http.get("https://atlas.mapmyindia.com/api/places/search/json?query"+searchText, headers: {HttpHeaders.authorizationHeader: "bearer $token"});
      if(result.statusCode == 200 || result.statusCode == 201) {
        print("Suggestions call successful with body = ${result.body}");
        var map = jsonDecode(result.body.toString());
        List<dynamic> places = map["suggestedLocations"];
        for(var place in places) {
          suggestionsList.add(SuggestedLocation.fromJson(place));
        }
      }
    }
    return suggestionsList;
  }

  @override
  void dispose() {
    latitude = "";
    longitude = "";
    print("Entered on Dispose");
    super.dispose();
  }
}