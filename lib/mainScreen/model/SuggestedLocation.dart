class SuggestedLocation implements Comparable {
  String name;
  double lattitude;
  double longitude;

  SuggestedLocation({
    this.lattitude,
    this.longitude,
    this.name
  });

  factory SuggestedLocation.fromJson(Map<String, dynamic> response) => SuggestedLocation(
    name: response["placeAddress"].toString() ?? "",
    lattitude: double.parse(response["latitude"].toString()) ?? 0.0,
    longitude: double.parse(response["longitude"].toString()) ?? 0.0
  );

  // Todo update logic of comparing storage spaces based on closeness with current location
  @override
  int compareTo(other) {
    return 0;
  }
}