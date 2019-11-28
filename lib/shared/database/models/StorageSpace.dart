import 'package:go_luggage_free/shared/utils/Helpers.dart';

class StorageSpaces {
  List<StorageSpace> list;

  StorageSpaces(this.list);

  factory StorageSpaces.fronMap(List<dynamic> listOfDynamic) {
    List<StorageSpace> newList = new List();
    listOfDynamic.forEach((item)  {
      print("Adding new item" + item.toString());
      try {
        newList.add(StorageSpace.fromResponse(item));
      } catch(e) {

      }
    });
    return new StorageSpaces(newList);
  }
}

class StorageSpace {
  String id;
  String name;
  String ownerName;
  List<String> storeImages;
  bool hasCCTV;
  String address;
  String longAddress;
  double rating;
  double costPerHour;
  String timings; 
  String ownerImage;
  String displayLocation;
  String location;
  String ownerDetail;
  bool open;

  StorageSpace({
    this.id,
    this.name,
    this.ownerImage,
    this.storeImages,
    this.hasCCTV,
    this.address,
    this.longAddress,
    this.rating,
    this.costPerHour,
    this.timings,
    this.ownerName,
    this.displayLocation,
    this.location,
    this.ownerDetail,
    this.open
  });

  factory StorageSpace.fromResponse(Map<String, dynamic> response) => new StorageSpace(
    id: response["_id"].toString() ?? "",
    name: response["name"].toString() ?? "",
    ownerImage: response["ownerImage"].toString() ?? "",
    address: response["address"].toString() ?? "",
    longAddress: response["longAddress"].toString() ?? "",
    rating: double.parse(response["rating"].toString()) ?? 0.0,
    costPerHour: double.parse(response["costPerHour"].toString()) ?? 0.0,
    hasCCTV: response["hasCCTV"] ?? true,
    ownerName: response["ownerName"].toString() ?? "",
    timings: response["timings"].toString() ?? "",
    storeImages: extractListFromJson(response["storeImages"]),
    displayLocation: response["area"]["name"].toString() + " Cloakroom",
    ownerDetail: response["ownerDetail"].toString() ?? "",
    open: response["open"] ?? false,
    location: response["location"] ?? "",
  );

  factory StorageSpace.fromResponseForBookings(Map<String, dynamic> response) => new StorageSpace(
    id: response["_id"].toString() ?? "",
    name: response["name"].toString() ?? "",
    displayLocation: response["area"]["name"].toString() ?? "",
    ownerImage: response["ownerImage"].toString() ?? "",
    address: response["address"].toString() ?? "",
    longAddress: response["longAddress"].toString() ?? "",
    location: response["location"].toString() ?? "",
    ownerDetail: response["ownerDetail"].toString() ?? "",
    open: response["open"] ?? false,
    ownerName: response["ownerName"].toString() ?? ""
  );

  factory StorageSpace.fromDatabaseResponse(Map<String, dynamic> response, List<String> images) => new StorageSpace(
    id: response["_id"].toString() ?? "",
    name: response["name"].toString() ?? "",
    ownerImage: response["ownerImage"].toString() ?? "",
    address: response["address"].toString() ?? "",
    longAddress: response["longAddress"].toString() ?? "",
    rating: double.parse(response["rating"].toString()) ?? 0.0,
    costPerHour: double.parse(response["costPerHour"].toString()) ?? 0.0,
    hasCCTV: response["hasCCTV"] == 1,
    ownerName: response["ownerName"].toString() ?? "",
    timings: response["timings"].toString() ?? "",
    storeImages: extractListFromJson(images),
    displayLocation: response["displayLocation"] ?? "",
    ownerDetail: response["ownerDetail"].toString() ?? "",
    open: response["open"] == 1,
    location: response["location"] ?? ""
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "ownerName": ownerName,
    "hasCCTV": hasCCTV ? 1 : 0,
    "address": address,
    "longAddress": longAddress,
    "rating": rating,
    "costPerHour": costPerHour,
    "timings": timings,
    "ownerImage": ownerImage,
    "displayLocation": displayLocation,
    "location": location,
    "ownerDetail": ownerDetail,
    "open": open ? 1 : 0
  };
}