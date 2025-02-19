import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showImageSourceDialog({
  required BuildContext context,
  required Function(ImageSource) onPickImage,
}) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () {
                Navigator.pop(context);
                onPickImage(ImageSource.gallery);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Pick from Camera'),
              onTap: () {
                Navigator.pop(context);
                onPickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      );
    },
  );
}
