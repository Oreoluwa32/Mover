import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/home_initial_model.dart';
import '../models/home_model.dart';
part 'home_state.dart';

final homeNotifier = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(HomeState(
    isSelectedSwitch: false,
    homeInitialModelObj: HomeInitialModel()
  )),
);

// A notifier that manages the state of the home screen according to the event that is dispatched to it
class HomeNotifier extends StateNotifier<HomeState>{
  HomeNotifier(HomeState state) : super(state);

  void changeSwitchBox(bool value) {
    state = state.copyWith(
      isSelectedSwitch: value,
    );
    if (value == false) {
      Text(
        "OFF",
      );
    } else {
      Text(
        "ON",
      );
    }
  }
}