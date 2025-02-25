import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/rating_model.dart';
part 'rating_state.dart';

final ratingNotifier = StateNotifierProvider.autoDispose<RatingNotifier, RatingState>(
  (ref) => RatingNotifier(RatingState()),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class RatingNotifier extends StateNotifier<RatingState> {
  RatingNotifier(RatingState state) : super(state);
}