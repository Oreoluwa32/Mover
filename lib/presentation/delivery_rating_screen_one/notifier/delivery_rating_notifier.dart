import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/delivery_rating_model.dart';
part 'delivery_rating_state.dart';

final deliveryRatingNotifier = StateNotifierProvider.autoDispose<DeliveryRatingNotifier, DeliveryRatingState>(
  (ref) => DeliveryRatingNotifier(DeliveryRatingState(
    descrController: TextEditingController()
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class DeliveryRatingNotifier extends StateNotifier<DeliveryRatingState> {
  DeliveryRatingNotifier(DeliveryRatingState state) : super(state);
}