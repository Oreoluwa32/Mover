import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/pickup_model.dart';
part 'pickup_state.dart';

final pickupNotifier = StateNotifierProvider.autoDispose<PickupNotifier, PickupState>(
  (ref) => PickupNotifier(PickupState()),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class PickupNotifier extends StateNotifier<PickupState> {
  PickupNotifier(PickupState state) : super(state);
}