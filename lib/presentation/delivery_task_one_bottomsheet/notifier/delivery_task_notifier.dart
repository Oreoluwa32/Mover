import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/delivery_task_item_model.dart';
import '../models/delivery_task_model.dart';
part 'delivery_task_state.dart';

final deliveryTaskNotifier =
    StateNotifierProvider.autoDispose<DeliveryTaskNotifier, DeliveryTaskState>(
  (ref) => DeliveryTaskNotifier(DeliveryTaskState(
    priceController: TextEditingController(),
    radioGroup: "",
    deliveryTaskModelObj: DeliveryTaskModel(deliveryTaskItemList: [
      DeliveryTaskItemModel(selectPrice: "400"),
      DeliveryTaskItemModel(selectPrice: "700"),
      DeliveryTaskItemModel(selectPrice: "1200"),
      DeliveryTaskItemModel(selectPrice: "1500")
    ]),
  )),
);

// A notifier that manages the state of the screen accroding to the event that is dispatched to it
class DeliveryTaskNotifier extends StateNotifier<DeliveryTaskState> {
  DeliveryTaskNotifier(DeliveryTaskState state) : super(state);

  void changeRadioButton(String value) {
    state = state.copyWith(radioGroup: value);
  }
}
