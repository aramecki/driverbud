import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

String? imageOne;
String? imageTwo;
String? imageThree;

// For debugging
Future<bool> startupImageLoader() async {
  try {
    final Directory docsDir = await getApplicationDocumentsDirectory();
    final Directory imagesDir = Directory(p.join(docsDir.path, 'images'));

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final List<String> assetNames = [
      'assets/images/0.jpg',
      'assets/images/1.jpg',
      'assets/images/2.jpg',
    ];

    for (final assetPath in assetNames) {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      final String fileName = p.basename(assetPath);
      final String destPath = p.join(imagesDir.path, fileName);
      final File destFile = File(destPath);

      await destFile.writeAsBytes(bytes, flush: true);
    }

    imageOne = p.join(imagesDir.path, '0.jpg');
    log('Image 1 is: $imageOne');
    imageTwo = p.join(imagesDir.path, '1.jpg');
    log('Image 1 is: $imageTwo');
    imageThree = p.join(imagesDir.path, '2.jpg');
    log('Image 1 is: $imageThree');

    return true;
  } catch (e) {
    log('Errore durante il caricamento delle immagini: $e');
    return false;
  }
}
