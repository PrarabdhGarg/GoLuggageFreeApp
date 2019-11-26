import 'package:go_luggage_free/CouponSelection/model/DiscountCoupon.dart';

class Coupon implements Comparable{
  String description;
  String title;
  String id;
  String expiryTime;
  bool isUseable;

  Coupon({
    this.title,
    this.description,
    this.expiryTime,
    this.id,
    this.isUseable
  });

  factory Coupon.fromJSON(Map<String, dynamic> response, bool isUseable) {
    print("Recived Response = ${response.toString()}");
    String type = response["type"];
    print("Type = $type");
    print("${double.parse(response["value"].toString())}\n${response["title"]}\n${response["_id"]}\n${response["description"]}\n${response["expiryTime"]}\n$isUseable");
    switch(type) {
      case "DISCOUNT" : {
        return DiscountCoupon(
          type: type,
          value: double.parse(response["value"].toString()),
          coupon: Coupon(
            title: response["title"],
            id: response["_id"],
            description: response["description"],
            expiryTime: response["expiryTime"],
            isUseable: isUseable,
          ),
        );
      }
      default: {
        return Coupon(
          title: response["title"],
          id: response["_id"],
          description: response["description"],
          expiryTime: response["expiryTime"],
          isUseable: isUseable,
        );
      }
    }
  }

  int getDiscountedPrice(double orignalPrice) {
    return orignalPrice.round();
  }

  @override
  int compareTo(other) {
    if(other is Coupon) {
      if(other != null) {
        if(this.isUseable && !(other.isUseable))
          return 1;
        else if(!(this.isUseable) && other.isUseable)
          return -1;
        return 0;
      }
    }
    return null;
  }

  String toString() {
    return "Description: ${description}\nid: ${id}";
  }
}