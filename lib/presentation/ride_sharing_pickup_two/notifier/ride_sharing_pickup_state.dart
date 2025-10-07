part of 'ride_sharing_pickup_notifier.dart';

// Represents the state of the screen in the app

// ignore for file, class must be immutable
class RideSharingPickupState extends Equatable{
  RideSharingPickupState({this.rideSharingPickupModelObj});

  RideSharingPickupModel? rideSharingPickupModelObj;

  @override
  List<Object?> get props => [rideSharingPickupModelObj];
  RideSharingPickupState copyWith({
    RideSharingPickupModel? rideSharingItemModelObj,
  }) {
    return RideSharingPickupState(
      rideSharingPickupModelObj: rideSharingItemModelObj ?? rideSharingPickupModelObj,
    );
  }
}