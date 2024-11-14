import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/splash_screen_one_model.dart';
part 'splash_screen_one_state.dart';

final splashScreenOneNotifier = StateNotifierProvider.autoDispose<SplashScreenOneNotifier, SplashScreenOneState>(
  (ref) => SplashScreenOneNotifier(SplashScreenOneState()),
);

// This notifier manages the state of a splash according to the event that is dispateched to it
class SplashScreenOneNotifier extends StateNotifier<SplashScreenOneState>{
  SplashScreenOneNotifier(SplashScreenOneState state) : super(state);
}