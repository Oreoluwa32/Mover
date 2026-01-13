import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/delivery_details_model.dart';
part 'delivery_details_state.dart';

final deliveryDetailsNotifier = StateNotifierProvider.autoDispose<
    DeliveryDetailsNotifier, DeliveryDetailsState>(
  (ref) => DeliveryDetailsNotifier(DeliveryDetailsState(
    pickupController: TextEditingController(),
    destinationController: TextEditingController(),
    itemDescrController: TextEditingController(),
    nameController: TextEditingController(),
    phoneController: TextEditingController(),
    radioGroup: "",
    itemWeight: "",
  )),
);

// A notifier that manages the state of delivery details according to the event that is dispatched to it
class DeliveryDetailsNotifier extends StateNotifier<DeliveryDetailsState> {
  DeliveryDetailsNotifier(DeliveryDetailsState state) : super(state);

  void changeRadioButton(String value) {
    state = state.copyWith(radioGroup: value);
  }

  void changeRadioBtn(String value) {
    state = state.copyWith(radioGroup: value);
  }

  void changeRadioButton1(String value) {
    state = state.copyWith(itemWeight: value);
  }

  // Update the state with the image path
  void uploadImage(String imagePath) {
    state = state.copyWith(imagePath: imagePath);
  }
}
