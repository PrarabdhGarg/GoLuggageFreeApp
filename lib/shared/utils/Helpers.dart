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
  print("Start = ${start.toString()}");
  print("End = ${end.toString()}");
  if(start == null || end == null) {
    print("Entered if for nill condition");
    return 1;
  }
  Duration diff = end.difference(start).abs();
  print("Difference = ${diff.toString()}");
  int hoursDifference = diff.inHours;
  if(hoursDifference == 0) {
    if(diff.inDays == 0) {
      return 1;
    } else {
      return diff.inDays;
    }
  } else {
    return (diff.inDays + 1);
  }
}

abstract class CustomBottomNavPageChangeListener{
  void onBottomNavPageChanged(int index);
}