part of 'share_ride_one_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class ShareRideOneState extends Equatable {
  ShareRideOneState({this.shareRideOneModelObj});

  ShareRideOneModel? shareRideOneModelObj;

  @override
  List<Object?> get props => [shareRideOneModelObj];
  ShareRideOneState copyWith({ShareRideOneModel? shareRideOneModelObj}) {
    return ShareRideOneState(
        shareRideOneModelObj:
            shareRideOneModelObj ?? this.shareRideOneModelObj);
  }
}
