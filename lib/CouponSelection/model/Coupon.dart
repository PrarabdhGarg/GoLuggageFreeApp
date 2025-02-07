class Coupon implements Comparable {
  String type;
  double value;
  String title;
  String description;
  String expiryTime;
  String id;
  bool isUseable;
  String code;
  String couponBenifitType;
  int maxBenefitValue;

  Coupon({
    this.type,
    this.value,
    this.title,
    this.description,
    this.expiryTime,
    this.id,
    this.isUseable,
    this.code,
    this.couponBenifitType,
    this.maxBenefitValue
  });

  factory Coupon.fromJSON(Map<String, dynamic> response, bool isUseable) => Coupon(
      type: response["type"],
      value: double.parse(response["value"].toString()),
      title: response["title"].toString(),
      id: response["_id"].toString(),
      description: response["description"].toString(),
      expiryTime: response["expiryTime"].toString(),
      isUseable: isUseable,
      code: response["code"].toString(),
      maxBenefitValue: response["maxBenefitValue"] != null ? int.parse(response["maxBenefitValue"]) : 100000,
      couponBenifitType: response["couponBenefitType"].toString()
  );

  int getDiscountedPrice(double orignalPrice) {
    double discountedPrice = orignalPrice;
    if(isUseable) {
      if(couponBenifitType == "PERCENTAGE") {
        double discount = value * 0.01 * orignalPrice;
        if(discount >= orignalPrice) {
          throw new Exception("Invalid discount Value");
        }
        if(discount >= maxBenefitValue) {
          discountedPrice = orignalPrice - maxBenefitValue;
        } else {
          discountedPrice = orignalPrice - discount;
        }
        return discountedPrice.round();
      } else if(couponBenifitType == "Flat") {
        discountedPrice = orignalPrice - value;
        return discountedPrice.round();
      }
      return orignalPrice.round();
    }
  }

  @override
  int compareTo(other) {
    if(other is Coupon) {
      if(other != null) {
        if(this.isUseable && !(other.isUseable))
          return -1;
        else if(!(this.isUseable) && other.isUseable)
          return 1;
        return 0;
      }
    }
    return 0;
  }
}