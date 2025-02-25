import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/delivery_pickup_item_model.dart';
import '../models/delivery_pickup_model.dart';
part 'delivery_pickup_state.dart';

final deliveryPickupNotifier = StateNotifierProvider.autoDispose<DeliveryPickupNotifier, DeliveryPickupState>(
  (ref) => DeliveryPickupNotifier(DeliveryPickupState(
    deliveryPickupModelObj: DeliveryPickupModel(deliveryPickupItemList: [
      DeliveryPickupItemModel(
        icon: ImageConstant.imgChatSquare,
        iconTitle: "Chat"
      ),
      DeliveryPickupItemModel(
        icon: ImageConstant.imgPhoneCall,
        iconTitle: "Call"
      ),
      DeliveryPickupItemModel(
        icon: ImageConstant.imgAlertCircle,
        iconTitle: "Report"
      ),
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class DeliveryPickupNotifier extends StateNotifier<DeliveryPickupState> {
  DeliveryPickupNotifier(DeliveryPickupState state) : super(state);
}