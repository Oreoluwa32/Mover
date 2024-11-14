import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/select_plan_model.dart';
part 'select_plan_state.dart';

final selectPlanNotifier = StateNotifierProvider.autoDispose<SelectPlanNotifier, SelectPlanState>(
  (ref) => SelectPlanNotifier(SelectPlanState()),
);

// A notifier that manages the state of select plan according to the event that is dispatched to it
class SelectPlanNotifier extends StateNotifier<SelectPlanState>{
  SelectPlanNotifier(SelectPlanState state) : super(state);
}