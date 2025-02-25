part of 'delivery_rating_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class DeliveryRatingState extends Equatable{
  DeliveryRatingState({this.descrController, this.deliveryRatingModelObj});

  TextEditingController? descrController;
  DeliveryRatingModel? deliveryRatingModelObj;

  @override
  List<Object?> get props => [descrController, deliveryRatingModelObj];
  DeliveryRatingState copyWith({
    TextEditingController? descrController,
    DeliveryRatingModel? deliveryRatingModelObj,
  }) {
    return DeliveryRatingState(
      descrController: descrController ?? this.descrController,
      deliveryRatingModelObj: deliveryRatingModelObj ?? this.deliveryRatingModelObj
    );
  }

}