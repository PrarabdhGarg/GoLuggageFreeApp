class Coupon {
  String type;
  int value;
  String description;
  String title;
  String id;
  String expiryTime;
  bool isUseable;

  Coupon({
    this.type,
    this.value,
    this.title,
    this.description,
    this.expiryTime,
    this.id,
    this.isUseable
  });

  factory Coupon.fromJsonResponse(Map<String, dynamic> response, bool isUseable) => Coupon(
    title: response["title"],
    type: response["type"],
    id: response["_id"],
    description: response["description"],
    expiryTime: response["expiryTime"],
    isUseable: isUseable,
    value: response["value"]
  );
}