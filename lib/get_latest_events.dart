import 'dart:developer';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/utils/sorting_funs.dart';

// TODO: Edit to only take vents from today or less
Map<dynamic, dynamic>? getLatestEvent(bool isMaintenance, int? vehicleKey) {
  final box = isMaintenance ? maintenanceBox : refuelingBox;
  final today = DateTime.now();

  if (vehicleKey != null) {
    List<dynamic> eventsList = sortByDate(
      maintenanceBox.keys
          .map((key) {
            final value = box.get(key);
            return {'key': key, 'value': value};
          })
          .where((m) => m['value']['vehicleKey'] == vehicleKey)
          .where((m) => m['value']['date'].compareTo(today) <= 0)
          .toList(),
      true,
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
