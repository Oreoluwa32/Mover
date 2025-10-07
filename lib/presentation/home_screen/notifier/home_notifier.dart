import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:new_project/presentation/home_one_screen/notifier/home_notifier.dart';
import '../../../core/app_export.dart';
import '../models/home_model.dart';
part 'home_state.dart';

final homeNotifier = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(HomeState()),
);

// A notifier that manages the state of the home screen according to the event that is dispatched to it
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier(HomeState state) : super(state);
}