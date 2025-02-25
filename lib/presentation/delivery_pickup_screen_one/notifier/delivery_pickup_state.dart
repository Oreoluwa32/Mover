part of 'delivery_pickup_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable 
class DeliveryPickupState extends Equatable{
  DeliveryPickupState({
    this.deliveryPickupModelObj,
  });

  DeliveryPickupModel? deliveryPickupModelObj;

  @override
  List<Object?> get props => [deliveryPickupModelObj];
  DeliveryPickupState copyWith({
    DeliveryPickupModel? deliveryPickupModelObj,
  }) {
    return DeliveryPickupState(
      deliveryPickupModelObj: deliveryPickupModelObj ?? this.deliveryPickupModelObj
    );
  }
}