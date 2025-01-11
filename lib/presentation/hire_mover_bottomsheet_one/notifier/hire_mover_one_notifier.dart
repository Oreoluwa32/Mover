import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:new_project/presentation/hire_mover_screen_one/notifier/hire_mover_one_notifier.dart';
import '../../../core/app_export.dart';
import '../models/hire_mover_one_model.dart';
part 'hire_mover_one_state.dart';

final hireMoverOneNotifier =
    StateNotifierProvider.autoDispose<HireMoverOneNotifier, HireMoverOneState>(
        (ref) => HireMoverOneNotifier(HireMoverOneState()));

// A notifier that manages the state of the screen according to the event that is dispatched to it
class HireMoverOneNotifier extends StateNotifier<HireMoverOneState> {
  HireMoverOneNotifier(HireMoverOneState state) : super(state);
}
