List<String> extractListFromJson(List<dynamic> list) {
  List<String> finalList = new List();
  list.forEach((item) => {
    finalList.add(item.toString())
  });
  return finalList;
}