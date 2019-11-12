import 'package:go_luggage_free/shared/utils/Helpers.dart';

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
    this.location
  });

  factory StorageSpace.fromResponse(Map<String, dynamic> response) => new StorageSpace(
    id: response["_id"].toString(),
    name: response["name"].toString(),
    ownerImage: response["ownerImage"].toString(),
    address: response["address"].toString(),
    longAddress: response["longAddress"].toString(),
    rating: double.parse(response["rating"].toString()),
    costPerHour: double.parse(response["costPerHour"].toString()),
    hasCCTV: response["hasCCTV"],
    ownerName: response["ownerName"].toString(),
    timings: response["timings"].toString(),
    storeImages: extractListFromJson(response["storeImages"]),
    displayLocation: response["area"]["name"].toString() + "Cloakroom"
  );

  factory StorageSpace.fromResponseForBookings(Map<String, dynamic> response) => new StorageSpace(
    id: response["_id"].toString(),
    name: response["name"].toString(),
    ownerImage: response["ownerImage"].toString(),
    address: response["address"].toString(),
    longAddress: response["longAddress"].toString(),
    location: response["location"].toString()
  );
}