// Fun to order list by 'date' DateTime
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

// Fun to order list by 'price' double
List<dynamic> sortByPrice(List<dynamic> items, bool isDecrementing) {
  items.sort((a, b) {
    final priceA = (a['value']['price'] ?? 0).toDouble();
    final priceB = (b['value']['price'] ?? 0).toDouble();
    return isDecrementing ? priceB.compareTo(priceA) : priceA.compareTo(priceB);
  });
  return items;
}
