import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mycargenie_2/notifications/notifications_utils.dart';
import 'package:mycargenie_2/utils/boxes.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/vehicle/add_vehicle.dart';
import 'package:mycargenie_2/vehicle/show_vehicle.dart';
import 'package:url_launcher/url_launcher.dart';

// Function to get the favorite vehicle key
int? getFavoriteKey() {
  for (final dynamic key in vehicleBox.keys) {
    final dynamic entry = vehicleBox.get(key);
    if (entry is Map && entry['favorite'] == true) {
      return key as int?;
    }
  }
  return null;
}

// Function to change the favorite vehicle key
Future<void> changeFavorite(dynamic newFavKey) async {
  final oldFavKey = getFavoriteKey();

  if (oldFavKey != null) {
    final oldFavItem = vehicleBox.get(oldFavKey) as Map;
    oldFavItem['favorite'] = false;
    vehicleBox.put(oldFavKey, oldFavItem);
  }

  final newFavItem = vehicleBox.get(newFavKey) as Map;
  newFavItem['favorite'] = true;
  vehicleBox.put(newFavKey, newFavItem);
}

// Function to open vehicle visualization screen
void openShowVehicle(BuildContext context, dynamic key) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => ShowVehicle(editKey: key)));
}

// Function to completely delete a vehicle entry from vehicleBox, its image and all its events
void deleteVehicle(
  VehicleProvider vehicleProvider,
  BuildContext context,
  dynamic key,
) async {
  final image = vehicleBox.get(key) as Map<dynamic, dynamic>?;
  final savedImagePath = image?['assetImage'] as String?;

  if (savedImagePath != null) {
    if (await File(savedImagePath).exists()) {
      await File(savedImagePath).delete();
      log('Image deleted');
    } else {
      log('Entry has path but image file doesnt exists, continuing deletion..');
    }
  } else {
    log('The vehicle has no image');
  }

  int? favoriteKey = getFavoriteKey();

  await vehicleBox.delete(key);

  await deleteAllEventsForVehicle(key);
  await deleteAllInvoicesForVehicle(key);

  if (favoriteKey == key) {
    if (vehicleBox.isNotEmpty) {
      final firstKey = vehicleBox.keyAt(0);
      log("New fav is: $firstKey");
      vehicleProvider.favoriteKey = firstKey;
      await changeFavorite(firstKey);
      vehicleProvider.vehicleToLoad = firstKey;
    } else {
      vehicleProvider.favoriteKey = null;
      vehicleProvider.vehicleToLoad = null;
    }
  } else {
    if (vehicleBox.isNotEmpty) {
      final firstKey = vehicleBox.keyAt(0);
      vehicleProvider.vehicleToLoad = firstKey;
    } else {
      vehicleProvider.vehicleToLoad = null;
    }
    log("You didn't delete favorite");
  }
}

Future<void> deleteAllEventsForVehicle(int vehicleKey) async {
  maintenanceBox.toMap().forEach((eventKey, eventValue) {
    if (eventValue['vehicleKey'] == vehicleKey) {
      maintenanceBox.delete(eventKey);
      log(
        'Deleting the maintenance event $eventValue at $eventKey for vehicle $vehicleKey',
      );
    }
  });

  deleteAllNotificationsInCategory(maintenanceNotificationsBox, vehicleKey);

  refuelingBox.toMap().forEach((eventKey, eventValue) {
    if (eventValue['vehicleKey'] == vehicleKey) {
      refuelingBox.delete(eventKey);
      log(
        'Deleting the refueling event $eventValue at $eventKey for vehicle $vehicleKey',
      );
    }
  });
}

Future<void> deleteAllInvoicesForVehicle(int vehicleKey) async {
  final dataBoxes = [insuranceBox, taxBox, inspectionBox];
  final notificationsBoxes = [
    insuranceNotificationsBox,
    taxNotificationsBox,
    inspectionNotificationsBox,
  ];

  for (final box in dataBoxes) {
    box.toMap().forEach((key, value) {
      if (value['vehicleKey'] == vehicleKey) {
        box.delete(key);
        log('Deleting the invoice $value at $key for vehicle $vehicleKey');
      }
    });
  }

  for (final box in notificationsBoxes) {
    deleteAllNotificationsInCategory(box, vehicleKey);
  }
}

// Function to open the vehicle editing screen
void openVehicleEditScreen(BuildContext context, dynamic key) {
  final Map<String, dynamic> vehicleMap = vehicleBox
      .get(key)!
      .cast<String, dynamic>();

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => AddVehicle(vehicle: vehicleMap, editKey: key),
    ),
  );
}

Future<void> mailContact(String subject) async {
  final address = 'test@test.test'; // TODO: Implement real mail
  final Uri url = Uri.parse('mailto:$address?subject=$subject');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
