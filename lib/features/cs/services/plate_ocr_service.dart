import 'dart:io';

import 'package:flutter_native_ocr/flutter_native_ocr.dart';
import 'package:image_picker/image_picker.dart';

class PlateOCRService {

  /// CAMERA OCR
  static Future<Map<String, dynamic>?> scanPlate() async {

    try {

      final picker = ImagePicker();

      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile == null) return null;

      final imageFile = File(pickedFile.path);

      final text =
      await FlutterNativeOcr().recognizeText(
        imageFile.path,
      );

      return {
        "text": text,
        "image": imageFile,
      };

    } catch (e) {

      print("OCR CAMERA ERROR: $e");

      return null;
    }
  }

  /// GALLERY OCR
  static Future<String?> scanPlateFromFile(
      File imageFile,
      ) async {

    try {

      final text =
      await FlutterNativeOcr().recognizeText(
        imageFile.path,
      );

      return text;

    } catch (e) {

      print("OCR FILE ERROR: $e");

      return null;
    }
  }
}