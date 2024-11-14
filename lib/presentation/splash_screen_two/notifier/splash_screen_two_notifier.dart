import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/splash_screen_two_model.dart';
part 'splash_screen_two_state.dart';

final splashScreenTwoNotifier = StateNotifierProvider.autoDispose<SplashScreenTwoNotifier, SplashScreenTwoState>(
  (ref) => SplashScreenTwoNotifier(SplashScreenTwoState()),
);

// This notifier manages the state of a splash according to the event that is dispateched to it
class SplashScreenTwoNotifier extends StateNotifier<SplashScreenTwoState>{
  SplashScreenTwoNotifier(SplashScreenTwoState state) : super(state);
}