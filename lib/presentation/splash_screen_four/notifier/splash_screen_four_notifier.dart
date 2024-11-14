import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/splash_screen_four_models.dart';
part 'splash_screen_four_state.dart';

final splashScreenFourNotifier = StateNotifierProvider.autoDispose<SplashScreenFourNotifier, SplashScreenFourState>(
  (ref) => SplashScreenFourNotifier(SplashScreenFourState()),
);

// This notifier manages the state of a splash according to the event that is dispateched to it
class SplashScreenFourNotifier extends StateNotifier<SplashScreenFourState>{
  SplashScreenFourNotifier(SplashScreenFourState state) : super(state);
}