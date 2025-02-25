part of 'pickup_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class PickupState extends Equatable{
  PickupState({this.pickupModelObj});

  PickupModel? pickupModelObj;

  @override
  List<Object?> get props => [pickupModelObj];
  PickupState copyWith({
    PickupModel? pickupModelObj,
  }) {
    return PickupState(
      pickupModelObj: pickupModelObj ?? this.pickupModelObj
    );
  }
}