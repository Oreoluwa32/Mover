import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/hire_mover_two_model.dart';
part 'hire_mover_two_state.dart';

final hireMoverTwoNotifier =
    StateNotifierProvider.autoDispose<HireMoverTwoNotifier, HireMoverTwoState>(
        (ref) => HireMoverTwoNotifier(HireMoverTwoState()));

// A notiifer that manages the state of the screen according to the event that is dispatched to it
class HireMoverTwoNotifier extends StateNotifier<HireMoverTwoState> {
  HireMoverTwoNotifier(HireMoverTwoState state) : super(state);
}
