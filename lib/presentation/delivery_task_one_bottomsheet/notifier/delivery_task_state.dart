part of 'delivery_task_notifier.dart';

// Represents the state of the screen in the app
//  ignore for file, class must be immutable
class DeliveryTaskState extends Equatable {
  DeliveryTaskState(
      {this.priceController, this.radioGroup = "", this.deliveryTaskModelObj});

  TextEditingController? priceController;
  String radioGroup;
  DeliveryTaskModel? deliveryTaskModelObj;

  @override
  List<Object?> get props =>
      [priceController, radioGroup, deliveryTaskModelObj];
  DeliveryTaskState copyWith(
      {TextEditingController? priceController,
      String? radioGroup,
      DeliveryTaskModel? deliveryTaskModelObj}) {
    return DeliveryTaskState(
        priceController: priceController ?? this.priceController,
        radioGroup: radioGroup ?? this.radioGroup,
        deliveryTaskModelObj:
            deliveryTaskModelObj ?? this.deliveryTaskModelObj);
  }
}
