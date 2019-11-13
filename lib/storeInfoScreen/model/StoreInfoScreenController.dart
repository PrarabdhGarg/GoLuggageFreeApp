import 'package:flutter/cupertino.dart';
import 'package:go_luggage_free/mainScreen/model/StorrageSpacesDAO.dart';
import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';

class StoreInfoScreenController with ChangeNotifier {
  String storeId;
  bool isLoading;
  StorageSpace storageSpace;
  String displayMessage = "";

  StoreInfoScreenController(this.storeId) {
    isLoading = true;
  }

  Future<Null> getStoreInfo() async {
    try {
      storageSpace = await StorageSpacesDAO.getStorageSpace(storeId);
      if(storageSpace == null) {
        displayMessage = "Unable to fetch data. Please try again after some time";
      }
    } catch (e) {
      displayMessage = "Exception Occoured. ${e.toString()}";
    }
    notifyListeners();
  }

  resetDisplayMessage() {
    this.displayMessage = "";
  }
}