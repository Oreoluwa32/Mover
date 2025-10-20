import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../app_export.dart';

class FileManager {
  // Shows a modal bottomsheet for selecting images from the gallery or camera
  // The [maxFileSize] parameter specifies the maximum size of the image file, in bytes
  // The [allowedExtensions] parameter is a list of allowed file extensions for upload
  // The [getImages] parameter is a callback function that is called when the user selects an image. It receives a list of image paths as its argument
  // Returns a [Future] that completes when the bottomsheet is dismissed
  showModelSheetForImage({
    int maxFileSize = 10 * 1024,
    List<String> allowedExtensions = const [],
    void Function(List<String?>)? getImages,
  }) async {
    // TODO: Implement modal sheet logic
  }

  // Retrieves a list of image paths selected from the gallery
  Future<List<String?>> getImagesFromGallery(
    int maxFileSize,
    List<String>? allowedExtensions,
  ) async {
    List<String?> files = [];
    final picker = ImagePicker();
    // Use pickImage instead of pickMultiImage to avoid ImageReader buffer exhaustion
    XFile? res1 = await picker.pickImage(source: ImageSource.gallery);
    if (res1 != null) {
      final fileExtension = path.extension(res1.path).replaceFirst('.', '');
      final fileSize = await res1.length();
      if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
        if (allowedExtensions.contains(fileExtension) && fileSize <= maxFileSize) {
          files.add(res1.path);
        }
      } else if (fileSize <= maxFileSize) {
        files.add(res1.path);
      }
    }
    return files;
  }

  Future<List<String?>> getImagesFromCamera(
    int maxFileSize,
    List<String>? allowedExtensions,
  ) async {
    List<String?> files = [];
    final picker = ImagePicker();
    XFile? res1 = await picker.pickImage(source: ImageSource.camera);
    if (res1 != null) {
      final fileExtension = path.extension(res1.path).replaceFirst('.', '');
      final fileSize = await res1.length();
      if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
        if (allowedExtensions.contains(fileExtension) && fileSize <= maxFileSize) {
          files.add(res1.path);
        } else {
          ScaffoldMessenger.of(NavigatorService.navigatorKey.currentContext!)
              .showSnackBar(
                SnackBar(content: Text('Only $allowedExtensions images are allowed'),)
              );
        }
      } else if (fileSize <= maxFileSize) {
        files.add(res1.path);
      }
    }
    return files;
  }
}