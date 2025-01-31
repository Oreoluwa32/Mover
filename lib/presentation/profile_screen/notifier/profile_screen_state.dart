part of 'profile_screen_notifier.dart';

// Represents the state of the profile screen
// ignore for file, class must be immutable
class ProfileScreenState extends Equatable{
  ProfileScreenState({this.profileScreenModelObj});

  ProfileScreenModel? profileScreenModelObj;

  @override
  List<Object?> get props => [profileScreenModelObj];
  ProfileScreenState copyWith({
    ProfileScreenModel? profileScreenModelObj
  }) {
    return ProfileScreenState(
      profileScreenModelObj: profileScreenModelObj ?? this.profileScreenModelObj
    );
  }
}