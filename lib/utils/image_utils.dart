import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  ImageUtils._();

  static Future<Uint8List?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List? picture = await image.readAsBytes();
      if (kIsWeb) {
        Image.network(image.path);
      } else {
        Image.file(File(image.path));
      }
      return picture;
    } else {
      debugPrint("沒有選擇圖片");
      return null;
    }
  }
}
