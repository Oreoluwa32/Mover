import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/ride_cancel_model.dart';
part 'ride_cancel_state.dart';

final rideCancelNotifier = StateNotifierProvider.autoDispose<RideCancelNotifier, RideCancelState>(
  (ref) => RideCancelNotifier(RideCancelState(
    radioGroup: ""
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it 
class RideCancelNotifier extends StateNotifier<RideCancelState> {
  RideCancelNotifier(RideCancelState state) : super(state);

  void changeRadioBtn(String value) {
    state = state.copyWith(radioGroup: value);
  }
}