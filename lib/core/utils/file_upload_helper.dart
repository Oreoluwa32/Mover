import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import '../app_export.dart';

class FileManager {
  // Shows a modal bottomsheet for selecting images from the gallery or camera
  // The [maxFileSize] parameter specifies the maximum size of the image file, in bytes
  // The [allowedExtensions] parameter is a list of allowed file extensionsfor upload
  // The [getImages] parameter is a callback function that is called when the user selects an image. It receives a list of image paths as its argument
  // Returns a [Future] that completes when the bottomsheet is dismissed
  showModelSheetForImage({
    int maxFileSize = 10 * 1024,
    List<String> allowedExtensions = const [],
    void Function(List<String?>)? getImages,
  }) async {}

  // Retrieves a list of image paths selected from the gallery
  // The [maxFileSize] parameter specifies the maximum sixe of the image file in bytes 
  // The [allowedExtensions] parameter is a list of allowed file extensions for the images
  // Returns a [Future] that completes with a list of image paths as its result
  Future<List<String?>> _getImagesFromGallery(
    int maxFileSize,
    List<String>? allowedExtensions,
  ) async {
    List<String?> files = [];
    List<Media>? res1 = await ImagesPicker.pick(
      pickType: PickType.image,
      maxSize: maxFileSize,
    );
    res1?.forEach((element) {
      var extension = element.path.split('.');
      if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
        if (allowedExtensions.contains(extension.last)) {
          files.add(element.path);
        } else {}
      } else {
        files.add(element.path);
      }
    });
    return files;
  }

  Future<List<String?>> getImagesFromCamera(
    int maxFileSize,
    List<String>? allowedExtensions,
  ) async {
    List<String?> files = [];
    List<Media>? res1 = await ImagesPicker.openCamera(
      pickType: PickType.image,
      maxSize: maxFileSize,
    );
    res1?.forEach((element) {
      var extension = element.path.split('.');
      if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
        if (allowedExtensions.contains(extension.last)) {
          files.add(element.path);
        } else {
          ScaffoldMessenger.of(NavigatorService.navigatorKey.currentContext!)
              .showSnackBar(
                SnackBar(content: Text('only $allowedExtensions images are allowed'),)
              );
        }
      } else {
        files.add(element.path);
      }
    });
    return files;
  }
}