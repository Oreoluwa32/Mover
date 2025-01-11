import 'package:equatable/equatable.dart';
import 'delivery_item_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class DeliveryModel extends Equatable {
  DeliveryModel({this.deliveryItemList = const []});

  List<DeliveryItemModel> deliveryItemList;

  DeliveryModel copyWith({List<DeliveryItemModel>? deliveryItemList}) {
    return DeliveryModel(
        deliveryItemList: deliveryItemList ?? this.deliveryItemList);
  }

  @override
  List<Object?> get props => [deliveryItemList];
}
