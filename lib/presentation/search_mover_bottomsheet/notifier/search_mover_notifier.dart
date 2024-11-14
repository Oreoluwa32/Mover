import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/search_mover_model.dart';
part 'search_mover_state.dart';

final searchMoverNotifier = StateNotifierProvider.autoDispose<SearchMoverNotifier, SearchMoverState>(
  (ref) => SearchMoverNotifier(SearchMoverState(
    radioGroup: "",
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class SearchMoverNotifier extends StateNotifier<SearchMoverState>{
  SearchMoverNotifier(SearchMoverState state) : super(state);

  void changeRadioButton(String value) {
    state = state.copyWith(radioGroup: value);
  }
}