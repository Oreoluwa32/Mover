import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import '../../../core/app_export.dart';
import '../../../core/utils/file_upload_helper.dart';
import '../models/profile_screen_model.dart';
part 'profile_screen_state.dart';

final profileScreenNotifier = StateNotifierProvider.autoDispose<ProfileScreenNotifier, ProfileScreenState>(
  (ref) => ProfileScreenNotifier(ProfileScreenState()),
);

// A notifier class that is used to manage the state of the profile screen according to the event that is dispatched to it
class ProfileScreenNotifier extends StateNotifier<ProfileScreenState>{
  ProfileScreenNotifier(ProfileScreenState state) : super(state);

  // Image constraints
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];

  /// Selects a profile image from gallery or camera and uploads it
  /// Returns true if successful, false otherwise
  Future<bool> selectAndUploadProfileImage({
    required bool useCamera,
  }) async {
    try {
      state = state.copyWith(
        isUploadingProfileImage: true,
        profileImageError: null,
      );

      List<String?> selectedImages = [];

      if (useCamera) {
        selectedImages = await FileManager().getImagesFromCamera(
          maxFileSize,
          allowedExtensions,
        );
      } else {
        selectedImages = await FileManager().getImagesFromGallery(
          maxFileSize,
          allowedExtensions,
        );
      }

      if (selectedImages.isEmpty) {
        state = state.copyWith(
          isUploadingProfileImage: false,
          profileImageError: 'No image selected',
        );
        return false;
      }

      String imagePath = selectedImages.first ?? '';
      
      // Validate image
      if (!_validateImage(imagePath)) {
        state = state.copyWith(
          isUploadingProfileImage: false,
          profileImageError: 'Invalid image file',
        );
        return false;
      }

      // Upload to backend (placeholder for now)
      bool uploadSuccess = await _uploadProfileImageToBackend(imagePath);

      if (uploadSuccess) {
        // Save image path locally for backend purposes
        await PrefUtils().setProfileImagePath(imagePath);
        
        state = state.copyWith(
          isUploadingProfileImage: false,
          profileImageError: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isUploadingProfileImage: false,
          profileImageError: 'Failed to upload image. Please try again.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isUploadingProfileImage: false,
        profileImageError: 'Error: ${e.toString()}',
      );
      return false;
    }
  }

  /// Validates the selected image
  bool _validateImage(String imagePath) {
    try {
      final file = File(imagePath);
      if (!file.existsSync()) {
        return false;
      }

      final fileExtension = path.extension(imagePath).replaceFirst('.', '').toLowerCase();
      if (!allowedExtensions.contains(fileExtension)) {
        return false;
      }

      final fileSize = file.lengthSync();
      if (fileSize > maxFileSize) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Uploads the profile image to the backend
  /// TODO: Replace with actual backend endpoint when ready
  Future<bool> _uploadProfileImageToBackend(String imagePath) async {
    try {
      // Placeholder implementation
      // Replace this with your actual API endpoint and logic
      final file = File(imagePath);
      
      // Example using multipart request:
      // var request = http.MultipartRequest('POST', Uri.parse('YOUR_API_ENDPOINT'));
      // request.files.add(await http.MultipartFile.fromPath('file', imagePath));
      // var response = await request.send();
      // return response.statusCode == 200;

      // For now, simulate successful upload
      await Future.delayed(Duration(seconds: 1));
      return true;
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      return false;
    }
  }

}