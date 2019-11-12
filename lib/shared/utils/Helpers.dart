import 'package:flutter/cupertino.dart';

List<String> extractListFromJson(List<dynamic> list) {
  List<String> finalList = new List();
  list.forEach((item) => {
    finalList.add(item.toString())
  });
  return finalList;
}
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}