import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mycargenie_2/boxes.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/vehicle/add_vehicle.dart';
import 'package:mycargenie_2/vehicle/show_vehicle.dart';

// Function to get the favourite vehicle key
int? getFavouriteKey() {
  for (final dynamic key in vehicleBox.keys) {
    final dynamic entry = vehicleBox.get(key);
    if (entry is Map && entry['favourite'] == true) {
      return key as int?;
    }
  }
  return null;
}

// Function to change the favourite vehicle key
void changeFavourite(dynamic newFavKey) {
  final oldFavKey = getFavouriteKey();

  if (oldFavKey != null) {
    final oldFavItem = vehicleBox.get(oldFavKey) as Map;
    oldFavItem['favourite'] = false;
    vehicleBox.put(oldFavKey, oldFavItem);
  }

  final newFavItem = vehicleBox.get(newFavKey) as Map;
  newFavItem['favourite'] = true;
  vehicleBox.put(newFavKey, newFavItem);
}

// Function to open vehicle visualization screen
void openShowVehicle(BuildContext context, dynamic key) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => ShowVehicle(editKey: key)));
}

// Function to completely delete a vehicle entry from vehicleBox and its image
void deleteVehicle(
  VehicleProvider vehicleProvider,
  BuildContext context,
  dynamic key,
) {
  final image = vehicleBox.get(key) as Map<dynamic, dynamic>?;
  final savedImagePath = image?['assetImage'] as String?;

  if (savedImagePath != null) {
    // String? savedImagePath = image!['assetImage'] as String?;
    File(savedImagePath).delete;
    log('Image deleted');
  } else {
    log('The vehicle has no image');
  }

  int? favouriteKey = getFavouriteKey();

  vehicleBox.delete(key);

  if (favouriteKey == key) {
    if (vehicleBox.isNotEmpty) {
      final firstKey = vehicleBox.keyAt(0);
      log("New fav is: $firstKey");
      vehicleProvider.favouriteKey = firstKey;
      changeFavourite(firstKey);
      vehicleProvider.vehicleToLoad = firstKey;
    } else {
      vehicleProvider.favouriteKey = null;
      vehicleProvider.vehicleToLoad = null;
    }
  } else {
    if (vehicleBox.isNotEmpty) {
      final firstKey = vehicleBox.keyAt(0);
      vehicleProvider.vehicleToLoad = firstKey;
    } else {
      vehicleProvider.vehicleToLoad = null;
    }
    log("You didn't delete favourite");
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
