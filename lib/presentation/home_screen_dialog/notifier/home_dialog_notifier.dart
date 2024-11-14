import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/home_dialog_model.dart';
part 'home_dialog_state.dart';

final homeDialogNotifier = StateNotifierProvider.autoDispose<HomeDialogNotifier, HomeDialogState>(
  (ref) => HomeDialogNotifier(HomeDialogState()),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class HomeDialogNotifier extends StateNotifier<HomeDialogState>{
  HomeDialogNotifier(HomeDialogState state) : super(state);
}