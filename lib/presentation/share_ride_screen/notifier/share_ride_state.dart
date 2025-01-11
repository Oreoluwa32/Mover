part of 'share_ride_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class ShareRideState extends Equatable {
  ShareRideState({this.shareRideModelObj});

  ShareRideModel? shareRideModelObj;

  @override
  List<Object?> get props => [shareRideModelObj];
  ShareRideState copyWith({ShareRideModel? shareRideModelObj}) {
    return ShareRideState(
        shareRideModelObj: shareRideModelObj ?? this.shareRideModelObj);
  }
}
