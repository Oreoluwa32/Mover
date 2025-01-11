import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/save_route_model.dart';
part 'save_route_state.dart';

final saveRouteNotifier =
    StateNotifierProvider.autoDispose<SaveRouteNotifier, SaveRouteState>(
  (ref) => SaveRouteNotifier(
      SaveRouteState(textController: TextEditingController())),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class SaveRouteNotifier extends StateNotifier<SaveRouteState> {
  SaveRouteNotifier(SaveRouteState state) : super(state);
}
