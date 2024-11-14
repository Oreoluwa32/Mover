import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/splash_screen_three_model.dart';
part 'splash_screen_three_state.dart';

final splashScreenThreeNotifier = StateNotifierProvider.autoDispose<SplashScreenThreeNotifier, SplashScreenThreeState>(
  (ref) => SplashScreenThreeNotifier(SplashScreenThreeState()),
);

// This notifier manages the state of a splash according to the event that is dispateched to it
class SplashScreenThreeNotifier extends StateNotifier<SplashScreenThreeState>{
  SplashScreenThreeNotifier(SplashScreenThreeState state) : super(state);
}