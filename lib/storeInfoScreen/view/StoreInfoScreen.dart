import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
          title: Text("Cloakroom"),
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
        child: Column(
          children: <Widget>[
            Container(
              child: CarouselSlider(
                aspectRatio: 16/9,
                autoPlay: true,
                scrollDirection: Axis.horizontal,
                items: _controller.storageSpace.storeImages.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(imageBaseUrl+image),
                      );
                    },
                  );
                }).toList()
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
}