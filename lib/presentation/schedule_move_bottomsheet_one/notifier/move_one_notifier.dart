import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/move_one_model.dart';
part 'move_one_state.dart';

final moveOneNotifier =
    StateNotifierProvider.autoDispose<MoveOneNotifier, MoveOneState>(
  (ref) => MoveOneNotifier(MoveOneState(
      dateController: TextEditingController(),
      timeController: TextEditingController())),
);

// A notifier that mannages the state of the screen according to the event that is dispatched to it
class MoveOneNotifier extends StateNotifier<MoveOneState> {
  MoveOneNotifier(MoveOneState state) : super(state);
}
