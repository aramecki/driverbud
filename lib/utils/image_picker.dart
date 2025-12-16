import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class VehicleImagePicker extends StatefulWidget {
  final ValueChanged<String?>? onImagePicked;
  final String? initialImagePath;

  const VehicleImagePicker({
    super.key,
    this.onImagePicked,
    this.initialImagePath,
  });

  @override
  VehicleImagePickerState createState() => VehicleImagePickerState();
}

class VehicleImagePickerState extends State<VehicleImagePicker> {
  String? imagePreview;
  String? srcPath;

  @override
  void initState() {
    super.initState();

    if (widget.initialImagePath != null &&
        widget.initialImagePath!.isNotEmpty) {
      imagePreview = widget.initialImagePath;
    }
  }

  Future<void> _selectAndShowImage() async {
    srcPath = await pickAndSaveImage();
    if (srcPath != null) {
      setState(() {
        imagePreview = showImagePreview(srcPath!);
      });
      widget.onImagePicked?.call(srcPath);
    } else {
      widget.onImagePicked?.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imagePreview == null
                  ? GestureDetector(
                      onTap: _selectAndShowImage,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.deepOrange,
                        child: Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: _selectAndShowImage,
                            icon: imageIcon(),
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: _selectAndShowImage,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: imagePreview != null
                            ? FileImage(File(imagePreview!))
                            : null,
                        child: Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: _selectAndShowImage,
                            icon: imageIcon(),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<String?> pickAndSaveImage() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: false,
  );
  if (result == null || result.files.isEmpty) return null;

  final String srcPath = result.files.first.path!;

  return srcPath;
}

String? showImagePreview(String srcPath) {
  final File srcFile = File(srcPath);
  return srcFile.path;
}

// TODO: Solve bug for image loading and saving on iOS
Future<String?> saveImageToMmry(String srcPath) async {
  final File srcFile = File(srcPath);

  final String timestamp = DateFormat(
    'yyyy-MM-dd_HH-mm-ss',
  ).format(DateTime.now());
  final String extension = p.extension(srcPath);
  final String newFileName = '$timestamp$extension';

  final Directory docsDir = await getApplicationDocumentsDirectory();
  final Directory imagesDir = Directory(p.join(docsDir.path, 'images'));
  if (!await imagesDir.exists()) await imagesDir.create(recursive: true);

  final String destPath = p.join(imagesDir.path, newFileName);
  await srcFile.copy(destPath);

  return destPath;
}
