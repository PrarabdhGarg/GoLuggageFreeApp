import 'package:flutter/cupertino.dart';
import 'package:go_luggage_free/mainScreen/model/StorrageSpacesDAO.dart';
import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';

class StoreInfoScreenController with ChangeNotifier {
  String storeId;
  bool isLoading;
  StorageSpace storageSpace;
  String displayMessage = "";

  StoreInfoScreenController(this.storeId) {
    print("Entered Constructor");
    isLoading = true;
    getStoreInfo();
  }

  Future<Null> getStoreInfo() async {
    print("Recived Store Id = $storeId");
    try {
      storageSpace = await StorageSpacesDAO.getStorageSpace(storeId);
      if(storageSpace == null) {
        displayMessage = "Unable to fetch data. Please try again after some time";
        isLoading = false;
      }
    } catch (e) {
      displayMessage = "Exception Occoured. ${e.toString()}";
    }
    print("Recived Storage Space ***********************************************************\n ${storageSpace.location.toString()}");
    isLoading = false;
    notifyListeners();
  }

  resetDisplayMessage() {
    this.displayMessage = "";
  }
}