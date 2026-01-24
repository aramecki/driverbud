// Fun to order list by 'date' DateTime

import 'package:hive/hive.dart';

List<dynamic> sortByDate(List<dynamic> items, bool isDecrementing) {
  items.sort((a, b) {
    final dateA = a['value']['date'] as DateTime;
    final dateB = b['value']['date'] as DateTime;
    return isDecrementing ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
  });
  return items;
}

// Fun to order list by 'title' String
List<dynamic> sortByName(List<dynamic> items, bool isDecrementing) {
  items.sort((a, b) {
    final titleA = (a['value']['title'] ?? '').toString().toLowerCase();
    final titleB = (b['value']['title'] ?? '').toString().toLowerCase();
    return isDecrementing ? titleB.compareTo(titleA) : titleA.compareTo(titleB);
  });
  return items;
}

// Fun to order list by double
List<dynamic> sortByDouble(
  List<dynamic> items,
  bool isDecrementing, {
  bool isPrice = true,
}) {
  String name = isPrice ? 'price' : 'fuelAmount';

  items.sort((a, b) {
    final priceA = (double.parse(a['value'][name]));
    final priceB = (double.parse(b['value'][name]));
    return isDecrementing ? priceB.compareTo(priceA) : priceA.compareTo(priceB);
  });
  return items;
}

List<Map<String, dynamic>> searchByText(
  Box<dynamic> items,
  String text, {
  bool isMaintenance = true,
}) {
  String field = isMaintenance ? 'title' : 'place';

  final lowerText = text.toLowerCase();

  return items.keys
      .map((key) {
        final value = items.get(key);
        return {'key': key, 'value': value};
      })
      .where(
        (item) =>
            item['value'][field].toString().toLowerCase().contains(lowerText),
      )
      .toList();
}
