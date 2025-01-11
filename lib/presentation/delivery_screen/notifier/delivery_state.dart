part of 'delivery_notifier.dart';

// Represents that state of the screen in the app
// ignore for file, class must be immutable
class DeliveryState extends Equatable {
  DeliveryState({this.deliveryModelObj});

  DeliveryModel? deliveryModelObj;

  @override
  List<Object?> get props => [deliveryModelObj];
  DeliveryState copyWith({DeliveryModel? deliveryModelObj}) {
    return DeliveryState(
        deliveryModelObj: deliveryModelObj ?? this.deliveryModelObj);
  }
}
