import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../../../core/app_export.dart';
import '../../../core/utils/file_upload_helper.dart';
import '../../../data/services/account_api_service.dart';
import '../models/profile_screen_model.dart';
part 'profile_screen_state.dart';

final profileScreenNotifier = StateNotifierProvider.autoDispose<
    ProfileScreenNotifier, ProfileScreenState>(
  (ref) => ProfileScreenNotifier(ref, ProfileScreenState()),
);

final userNameProvider = FutureProvider.autoDispose<String?>((ref) async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: 'user_name');
});

// Helper provider to read the initial profile image path from SharedPreferences
final profileImagePathProvider =
    FutureProvider.autoDispose<String?>((ref) async {
  return await PrefUtils().getProfileImagePath();
});

// A provider to track the profile image path globally and allow immediate UI updates
final globalProfileImagePathProvider =
    StateNotifierProvider<GlobalProfileImageNotifier, String?>((ref) {
  return GlobalProfileImageNotifier(ref);
});

class GlobalProfileImageNotifier extends StateNotifier<String?> {
  GlobalProfileImageNotifier(this.ref) : super(null) {
    _init();
  }

  final Ref ref;

  Future<void> _init() async {
    final initialPath = await ref.read(profileImagePathProvider.future);
    if (state == null && initialPath != null) {
      state = initialPath;
    }
  }

  void updatePath(String? path) {
    debugPrint('Updating global profile image path to: $path');
    state = path;
  }
}

// A notifier class that is used to manage the state of the profile screen according to the event that is dispatched to it
class ProfileScreenNotifier extends StateNotifier<ProfileScreenState> {
  ProfileScreenNotifier(this.ref, ProfileScreenState state) : super(state);

  final Ref ref;

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
      debugPrint('Selected image path: $imagePath');

      // Update state with local path immediately for UI feedback
      state = state.copyWith(selectedLocalImagePath: imagePath);
      // Also update global provider for bottom bar
      debugPrint('Updating globalProfileImagePathProvider with local path');
      ref.read(globalProfileImagePathProvider.notifier).updatePath(imagePath);

      // Validate image
      if (!_validateImage(imagePath)) {
        debugPrint('Image validation failed');
        state = state.copyWith(
          isUploadingProfileImage: false,
          profileImageError: 'Invalid image file',
        );
        return false;
      }

      // Upload to backend
      debugPrint('Starting upload to backend...');
      String? uploadedImageUrl = await _uploadProfileImageToBackend(imagePath);

      if (uploadedImageUrl != null) {
        debugPrint('Upload successful, URL: $uploadedImageUrl');
        // Save image URL locally for syncing purposes
        await PrefUtils().setProfileImagePath(uploadedImageUrl);

        // Update global provider with the network URL
        debugPrint('Updating globalProfileImagePathProvider with network URL');
        ref
            .read(globalProfileImagePathProvider.notifier)
            .updatePath(uploadedImageUrl);

        state = state.copyWith(
          isUploadingProfileImage: false,
          profileImageError: null,
        );
        return true;
      } else {
        debugPrint('Upload failed or URL is null');
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

      final fileExtension =
          path.extension(imagePath).replaceFirst('.', '').toLowerCase();
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
      final response = await AccountApiService().updateProfile(
        avatarFilePath: imagePath,
      );
      final avatarUrl = response['avatar_url']?.toString();
      if (avatarUrl == null || avatarUrl.isEmpty) {
        state = state.copyWith(
          profileImageError:
              'Profile image uploaded, but no avatar URL was returned.',
        );
        return null;
      }
      return avatarUrl;
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      state = state.copyWith(profileImageError: 'An error occurred: $e');
      return null;
    }
  }
}
