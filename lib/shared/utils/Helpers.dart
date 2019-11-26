import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> extractListFromJson(List<dynamic> list) {
  List<String> finalList = new List();
  if(list.isNotEmpty) {
    list.forEach((item) => {
      finalList.add(item.toString())
    });
  }
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


String getHumanReadableDate(DateTime dateTime) {
  return dateTime.day.toString() + "-" + dateTime.month.toString() + "-" + dateTime.year.toString();
}


String getUserReadableTime(DateTime dateTime) {
  return dateTime.hour.toString() + ":" + dateTime.minute.toString();
}

int calculateNumberOfDays(DateTime start, DateTime end) {
  Duration diff = end.difference(start).abs();
  if(diff.inHours % 24 == 0)
    return diff.inDays;
  else
    return (diff.inDays + 1);
}