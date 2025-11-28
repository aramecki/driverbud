import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:mycargenie_2/home.dart';

bool _isIsoString(String value) {
  try {
    DateTime.parse(value);
    return true;
  } catch (_) {
    return false;
  }
}

Map<dynamic, dynamic> _checkJsonForMap(Map<dynamic, dynamic> jsonMap) {
  final Map<dynamic, dynamic> checkedMap = {};

  jsonMap.forEach((key, value) {
    dynamic checkedValue = value;

    if (value is String && _isIsoString(value)) {
      checkedValue = DateTime.parse(value);
    } else if (value is Map) {
      checkedValue = _checkJsonForMap(value);
    } else if (value is List) {
      checkedValue = value
          .map((e) => (e is Map) ? _checkJsonForMap(e) : e)
          .toList();
    }

    dynamic hiveKey = int.tryParse(key.toString()) ?? key;

    checkedMap[hiveKey] = checkedValue;
  });

  return checkedMap;
}

Future<bool> restoreBoxFromPath(VehicleProvider vehicleProvider) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) {
      return false;
    }

    final String filePath = result.files.single.path!;
    final File file = File(filePath);

    final String jsonString = await file.readAsString();

    final Map<dynamic, dynamic> stringMap = json.decode(jsonString);

    for (final boxName in stringMap.keys) {
      final Map<dynamic, dynamic> stringDataForBox =
          stringMap[boxName] as Map<dynamic, dynamic>;
      final Map<dynamic, dynamic> restoredData = _checkJsonForMap(
        stringDataForBox,
      );

      final box = await Hive.openBox(boxName);

      await box.clear();
      await box.putAll(restoredData);
      log('Restored $boxName from $filePath');
    }

    log('Restore completed from $filePath');
    // final firstKey = vehicleBox.keyAt(0);
    // vehicleProvider.vehicleToLoad = firstKey;
    vehicleProvider.loadInitialData();
    return true;
  } catch (e) {
    log('Error while restoring $e');
    return false;
  }
}
