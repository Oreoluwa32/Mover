import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/hire_mover_one_model.dart';
part 'hire_mover_one_state.dart';

final hireMoverOneNotifier =
    StateNotifierProvider.autoDispose<HireMoverOneNotifier, HireMoverOneState>(
  (ref) => HireMoverOneNotifier(HireMoverOneState()),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class HireMoverOneNotifier extends StateNotifier<HireMoverOneState> {
  HireMoverOneNotifier(HireMoverOneState state) : super(state);
}
