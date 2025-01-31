import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/completed_model.dart';
part 'completed_state.dart';

final completedNotifier = StateNotifierProvider.autoDispose<CompletedNotifier, CompletedState>(
  (ref) => CompletedNotifier(CompletedState()),
);

// A notifier class that is used to manage the state of the completed bottom sheet screen according to the event that is dispatched to it
class CompletedNotifier extends StateNotifier<CompletedState>{
  CompletedNotifier(CompletedState state) : super(state);
}