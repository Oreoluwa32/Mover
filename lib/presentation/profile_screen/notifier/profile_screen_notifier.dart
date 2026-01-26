import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../../../core/app_export.dart';
import '../../../core/utils/file_upload_helper.dart';
import '../models/profile_screen_model.dart';
part 'profile_screen_state.dart';

final profileScreenNotifier = StateNotifierProvider.autoDispose<ProfileScreenNotifier, ProfileScreenState>(
  (ref) => ProfileScreenNotifier(ProfileScreenState()),
);

final userNameProvider = FutureProvider.autoDispose<String?>((ref) async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: 'user_name');
});

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

      // Upload to backend
      String? uploadedImageUrl = await _uploadProfileImageToBackend(imagePath);

      if (uploadedImageUrl != null) {
        // Save image URL locally for syncing purposes
        await PrefUtils().setProfileImagePath(uploadedImageUrl);
        
        state = state.copyWith(
          isUploadingProfileImage: false,
          profileImageError: null,
        );
        return true;
      } else {
        // profileImageError is already set in _uploadProfileImageToBackend if it failed
        state = state.copyWith(
          isUploadingProfileImage: false,
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
  /// Returns the URL of the uploaded image if successful, null otherwise
  Future<String?> _uploadProfileImageToBackend(String imagePath) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      
      if (token == null) {
        debugPrint('No auth token found');
        state = state.copyWith(profileImageError: 'Session expired. Please log in again.');
        return null;
      }

      final url = Uri.parse('https://demosystem.pythonanywhere.com/upload-profile-image/');
      var request = http.MultipartRequest('POST', url);
      
      // Add authorization header
      request.headers['Authorization'] = 'Token $token';
      
      // Add the file with explicit MIME type
      final extension = path.extension(imagePath).replaceFirst('.', '').toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
      
      request.files.add(await http.MultipartFile.fromPath(
        'profile_picture',
        imagePath,
        contentType: MediaType.parse(mimeType),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        debugPrint('Upload success. Response body: ${response.body}');
        
        // Extract URL from root or nested 'user' object
        var imageUrl = responseData['profile_picture'] ?? 
                       responseData['profile_image'] ?? 
                       responseData['image_url'] ?? 
                       responseData['image'];
                       
        if (imageUrl == null && responseData['user'] != null) {
          imageUrl = responseData['user']['profile_picture'] ?? 
                     responseData['user']['profile_image'] ?? 
                     responseData['user']['image_url'] ?? 
                     responseData['user']['image'];
        }
        
        if (imageUrl == null) {
          state = state.copyWith(profileImageError: 'Image uploaded but URL not found in response');
          return null;
        }
        
        // Prepend base URL if it's a relative path
        String finalUrl = imageUrl.toString();
        if (finalUrl.startsWith('/')) {
          finalUrl = 'https://demosystem.pythonanywhere.com$finalUrl';
        }
        
        return finalUrl;
      } else {
        debugPrint('Upload failed with status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        
        String errorMessage = 'Failed to upload image (${response.statusCode})';
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['detail'] ?? errorData['message'] ?? errorData['error'] ?? errorMessage;
        } catch (_) {}
        
        state = state.copyWith(profileImageError: errorMessage);
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      state = state.copyWith(profileImageError: 'An error occurred: $e');
      return null;
    }
  }

}