import 'dart:developer';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/utils/sorting_funs.dart';

Map<dynamic, dynamic>? getNextOrLatestEvent(
  bool isMaintenance,
  bool getLatest,
  int? vehicleKey,
) {
  final box = isMaintenance ? maintenanceBox : refuelingBox;
  final today = DateTime.now();
  final todayClean = DateTime(today.year, today.month, today.day);

  if (vehicleKey != null) {
    List<dynamic> eventsList = sortByDate(
      box.keys
          .map((key) {
            final value = box.get(key);
            return {'key': key, 'value': value};
          })
          .where((m) => m['value']['vehicleKey'] == vehicleKey)
          .where(
            getLatest
                ? (m) => m['value']['date'].compareTo(todayClean) < 0
                : (m) => m['value']['date'].compareTo(todayClean) >= 0,
          )
          .toList(),
      false,
    );
    if (eventsList.isNotEmpty) {
      log('returning latest event ${eventsList[0]}');
      return eventsList[0];
    } else {
      log('returning null');
      return null;
    }
  } else {
    log('returning null because vehicleKey is null');
    return null;
  }
}
