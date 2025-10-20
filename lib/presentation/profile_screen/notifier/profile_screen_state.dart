part of 'profile_screen_notifier.dart';

// Represents the state of the profile screen
// ignore for file, class must be immutable
class ProfileScreenState extends Equatable{
  ProfileScreenState({
    this.profileScreenModelObj,
    this.isUploadingProfileImage = false,
    this.profileImageError,
  });

  ProfileScreenModel? profileScreenModelObj;
  bool isUploadingProfileImage;
  String? profileImageError;

  @override
  List<Object?> get props => [profileScreenModelObj, isUploadingProfileImage, profileImageError];
  
  ProfileScreenState copyWith({
    ProfileScreenModel? profileScreenModelObj,
    bool? isUploadingProfileImage,
    String? profileImageError,
  }) {
    return ProfileScreenState(
      profileScreenModelObj: profileScreenModelObj ?? this.profileScreenModelObj,
      isUploadingProfileImage: isUploadingProfileImage ?? this.isUploadingProfileImage,
      profileImageError: profileImageError ?? this.profileImageError,
    );
  }
}