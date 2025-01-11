import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/delivery_model.dart';
import '../models/delivery_item_model.dart';
part 'delivery_state.dart';

final deliveryNotifier =
    StateNotifierProvider.autoDispose<DeliveryNotifier, DeliveryState>(
  (ref) => DeliveryNotifier(DeliveryState(
    deliveryModelObj: DeliveryModel(deliveryItemList: [
      DeliveryItemModel(
          name: "Jessica Grace",
          star: "5.0",
          time: "1 hour ago",
          review:
              "Prompt delivery and top-notch quality. Impressed with the speed and accuracy. The efficiency and speed at which he delivered the package was impressive."),
      DeliveryItemModel(
          name: "Jessica Grace",
          star: "5.0",
          time: "1 hour ago",
          review:
              "Prompt delivery and top-notch quality. Impressed with the speed and accuracy. The efficiency and speed at which he delivered the package was impressive."),
      DeliveryItemModel(
          name: "Jessica Grace",
          star: "5.0",
          time: "1 hour ago",
          review:
              "Prompt delivery and top-notch quality. Impressed with the speed and accuracy. The efficiency and speed at which he delivered the package was impressive."),
      DeliveryItemModel(
          name: "Jessica Grace",
          star: "5.0",
          time: "1 hour ago",
          review:
              "Prompt delivery and top-notch quality. Impressed with the speed and accuracy. The efficiency and speed at which he delivered the package was impressive."),
      DeliveryItemModel(
          name: "Jessica Grace",
          star: "5.0",
          time: "1 hour ago",
          review:
              "Prompt delivery and top-notch quality. Impressed with the speed and accuracy. The efficiency and speed at which he delivered the package was impressive."),
      DeliveryItemModel(
          name: "Jessica Grace",
          star: "5.0",
          time: "1 hour ago",
          review:
              "Prompt delivery and top-notch quality. Impressed with the speed and accuracy. The efficiency and speed at which he delivered the package was impressive."),
      DeliveryItemModel()
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class DeliveryNotifier extends StateNotifier<DeliveryState> {
  DeliveryNotifier(DeliveryState state) : super(state);
}
