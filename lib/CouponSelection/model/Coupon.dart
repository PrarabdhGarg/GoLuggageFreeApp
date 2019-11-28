import 'package:go_luggage_free/CouponSelection/model/Coupon.dart';

class DiscountCoupon extends Coupon {
  String type;
  double value;

  DiscountCoupon({
    this.type,
    this.value,
    title,
    description,
    expiryTime,
    id,
    isUseable
  });

  int getDiscountedPrice(double orignalPrice) {
    if(isUseable) {
      double discount = value * 0.01 * orignalPrice;
      if(discount >= orignalPrice) {
        throw new Exception("Invalid discount Value");
      }
      double discountedPrice = orignalPrice = discount;
      return discountedPrice.round();
    }
    return orignalPrice.round();
  }
}