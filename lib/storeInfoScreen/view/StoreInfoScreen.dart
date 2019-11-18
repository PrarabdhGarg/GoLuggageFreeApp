import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_luggage_free/bookingForm/view/BookingFromScreen.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';
import 'package:go_luggage_free/storeInfoScreen/model/StoreInfoScreenController.dart';
import 'package:provider/provider.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';

class StoreInfoScreen extends StatefulWidget {
  String storeId;

  StoreInfoScreen(this.storeId);

  @override
  _StoreInfoScreenState createState() => _StoreInfoScreenState();
}

class _StoreInfoScreenState extends State<StoreInfoScreen> {
  
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoreInfoScreenController>(
      builder: (BuildContext context) => StoreInfoScreenController(widget.storeId),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cloakroom", style: Theme.of(context).textTheme.title,),
          leading :IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black,),
            onPressed:() => Navigator.pop(context, false)
          )
        ),
        body: StoreInfoPage(),
      ),
    );
  }  
}

class StoreInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   final StoreInfoScreenController _controller = Provider.of<StoreInfoScreenController>(context);
    return _controller.isLoading ? Center(child: CircularProgressIndicator(),) : 
    _controller.displayMessage.isNotEmpty ? showErrorMessage(_controller.displayMessage) : SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                autoPlay: true,
                scrollDirection: Axis.horizontal,
                items: _controller.storageSpace.storeImages.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageBaseUrl+image),
                            fit: BoxFit.fitWidth
                          ),
                        ),
                      );
                    },
                  );
                }).toList()
              ),
            ),
            Container(
              margin: EdgeInsets.all(24.0),
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
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_controller.storageSpace.name, style: Theme.of(context).textTheme.headline),
                            Text(_controller.storageSpace.displayLocation, style: Theme.of(context).textTheme.body1,),
                            Container(height: 10,),
                            Container(child: Text(_controller.storageSpace.ownerDetail,style: Theme.of(context).textTheme.body1,),)
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.none,
                                    image: NetworkImage(imageBaseUrl + _controller.storageSpace.ownerImage)
                                  )
                                ),
                              ),
                              Text(_controller.storageSpace.ownerName, style: Theme.of(context).textTheme.body1,)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(color: Colors.grey[300],),
                  Text(_controller.storageSpace.address, style: Theme.of(context).textTheme.body1,),
                  Divider(color: Colors.grey[300],),
                  infoRow("Has CCTV", _controller.storageSpace.hasCCTV ? "Yes" : "No", Theme.of(context).textTheme.headline),
                  Divider(color: Colors.grey[300],),
                  infoRow("Current Status", _controller.storageSpace.open ? "Open" : "Closed", Theme.of(context).textTheme.headline),
                  Divider(color: Colors.grey[300],),
                  infoRow("Store Tmings", _controller.storageSpace.timings, Theme.of(context).textTheme.headline),
                  Divider(color: Colors.grey[300],),
                  infoRow("Price(per bag per day)", ((_controller.storageSpace.costPerHour*24.0).round()).toString(), Theme.of(context).textTheme.headline),
                  Container(height: 20,)
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 24.0, right: 24.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Theme.of(context).buttonColor
              ),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookingFormScreen(_controller.storageSpace.costPerHour.round())));
                },
                child: Text("Book Now", style: Theme.of(context).textTheme.button,),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showErrorMessage(String errorMessage) {
    return Center(child: Text(errorMessage),);
  }

  Widget infoRow(String text1, String text2, TextStyle style) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(text1, style: style,),
        ),
        Text(text2)
      ],
    );
  }
}