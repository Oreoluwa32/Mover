import 'package:equatable/equatable.dart';
import 'delivery_task_item_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class DeliveryTaskModel extends Equatable {
  DeliveryTaskModel({this.deliveryTaskItemList = const []});

  List<DeliveryTaskItemModel> deliveryTaskItemList;

  DeliveryTaskModel copyWith(
      {List<DeliveryTaskItemModel>? deliveryTaskItemList}) {
    return DeliveryTaskModel(
        deliveryTaskItemList:
            deliveryTaskItemList ?? this.deliveryTaskItemList);
  }

  @override
  List<Object?> get props => [deliveryTaskItemList];
}
