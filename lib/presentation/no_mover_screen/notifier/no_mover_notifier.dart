import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/no_mover_model.dart';
part 'no_mover_state.dart';

final noMoverNotifier = StateNotifierProvider.autoDispose<NoMoverNotifier, NoMoverState>(
    (ref) => NoMoverNotifier(NoMoverState()),
);

// A notifier that manages the state of the screen according to the event dispatched to it
class NoMoverNotifier extends StateNotifier<NoMoverState>{
    NoMoverNotifier(NoMoverState state) : super(state);
}