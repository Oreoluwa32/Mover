import 'package:equatable/equatable.dart';
import 'delivery_pickup_item_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class DeliveryPickupModel extends Equatable{
  DeliveryPickupModel({this.deliveryPickupItemList = const []});

  List<DeliveryPickupItemModel> deliveryPickupItemList;

  DeliveryPickupModel copyWith({
    List<DeliveryPickupItemModel>? deliveryPickupItemList
  }) {
    return DeliveryPickupModel(
      deliveryPickupItemList: deliveryPickupItemList ?? this.deliveryPickupItemList,
    );
  }

  @override
  List<Object?> get props => [deliveryPickupItemList];
}