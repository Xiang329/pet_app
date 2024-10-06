import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  ImageUtils._();

  static Future<Uint8List?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 60,
      requestFullMetadata: false,
    );

    if (image != null) {
      Uint8List? picture = await image.readAsBytes();
      debugPrint('picture_lengthInBytes:${picture.lengthInBytes}');

      return picture;
    } else {
      debugPrint("沒有選擇圖片");
      return null;
    }
  }
}
