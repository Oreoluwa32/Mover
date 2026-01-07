import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../app_export.dart';

class FileManager {
  static const int maxWidth = 800;
  static const int maxHeight = 400;
  static const int maxFileSize = 5 * 1024 * 1024;



  // Shows a modal bottomsheet for selecting images from the gallery or camera
  // The [maxFileSize] parameter specifies the maximum size of the image file, in bytes
  // The [allowedExtensions] parameter is a list of allowed file extensions for upload
  // The [getImages] parameter is a callback function that is called when the user selects an image. It receives a list of image paths as its argument
  // Returns a [Future] that completes when the bottomsheet is dismissed
  showModelSheetForImage({
    int maxFileSize = 5 * 1024 * 1024,
    List<String> allowedExtensions = const [],
    void Function(List<String?>)? getImages,
  }) async {
    showModalBottomSheet(
      context: NavigatorService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    final images = await getImagesFromCamera(
                      maxFileSize,
                      allowedExtensions.isEmpty ? null : allowedExtensions,
                    );
                    getImages?.call(images);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    final images = await getImagesFromGallery(
                      maxFileSize,
                      allowedExtensions.isEmpty ? null : allowedExtensions,
                    );
                    getImages?.call(images);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Retrieves a list of image paths selected from the gallery
  Future<List<String?>> getImagesFromGallery(
    int maxFileSize,
    List<String>? allowedExtensions,
  ) async {
    List<String?> files = [];
    final picker = ImagePicker();
    XFile? res1 = await picker.pickImage(source: ImageSource.gallery);
    if (res1 != null) {
      final fileExtension = path.extension(res1.path).replaceFirst('.', '');
      final fileSize = await res1.length();
      
      if (fileSize > maxFileSize) {
        ScaffoldMessenger.of(NavigatorService.navigatorKey.currentContext!)
            .showSnackBar(
          SnackBar(
            content: Text(
              'File size exceeds limit of ${(maxFileSize / (1024 * 1024)).toStringAsFixed(2)} MB',
            ),
          ),
        );
        return files;
      }
      
      if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
        if (!allowedExtensions.contains(fileExtension)) {
          ScaffoldMessenger.of(NavigatorService.navigatorKey.currentContext!)
              .showSnackBar(
            SnackBar(
              content: Text('Only $allowedExtensions images are allowed'),
            ),
          );
          return files;
        }
      }
      
      files.add(res1.path);
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
      
      if (fileSize > maxFileSize) {
        ScaffoldMessenger.of(NavigatorService.navigatorKey.currentContext!)
            .showSnackBar(
          SnackBar(
            content: Text(
              'File size exceeds limit of ${(maxFileSize / (1024 * 1024)).toStringAsFixed(2)} MB',
            ),
          ),
        );
        return files;
      }
      
      if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
        if (!allowedExtensions.contains(fileExtension)) {
          ScaffoldMessenger.of(NavigatorService.navigatorKey.currentContext!)
              .showSnackBar(
            SnackBar(
              content: Text('Only $allowedExtensions images are allowed'),
            ),
          );
          return files;
        }
      }
      
      files.add(res1.path);
    }
    return files;
  }
}