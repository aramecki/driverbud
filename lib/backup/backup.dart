import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';

dynamic _checkMapForJson(Map<dynamic, dynamic> boxMap) {
  final Map<String, dynamic> checkedMap = {};

  boxMap.forEach((key, value) {
    final String checkedKey = key.toString();

    dynamic checkedValue = value;

    if (value is DateTime) {
      checkedValue = value.toIso8601String();
    } else if (value is Map) {
      checkedValue = _checkMapForJson(value);
    } else if (value is List) {
      checkedValue = value
          .map((e) => (e is Map) ? _checkMapForJson(e) : e)
          .toList();
    }
    checkedMap[checkedKey] = checkedValue;
  });

  return checkedMap;
}

Future<String?> backupBoxesToPath(List<String> boxNames) async {
  try {
    final Map<String, dynamic> completeBackupData = {};

    for (final boxName in boxNames) {
      final box = await Hive.openBox(boxName);
      final Map<dynamic, dynamic> data = box.toMap();

      final Map<String, dynamic> dataToSave = _checkMapForJson(data);
      completeBackupData[boxName] = dataToSave;
    }

    final String jsonString = jsonEncode(completeBackupData);

    final Uint8List fileBytes = Uint8List.fromList(utf8.encode(jsonString));

    final today = DateTime.now();

    final String filename =
        'mcg_backup_${today.year}_${today.month}_${today.day}.json';

    final String? selectedPath = await FilePicker.platform.saveFile(
      fileName: filename,
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: fileBytes,
    );

    if (selectedPath != null) {
      return selectedPath;
    }
    return null;
  } catch (e) {
    log('Backup error: $e');
    return null;
  }
}
