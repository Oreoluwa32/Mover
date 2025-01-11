import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/route_setting_model.dart';
part 'route_setting_state.dart';

final routeSettingNotifier =
    StateNotifierProvider.autoDispose<RouteSettingNotifier, RouteSettingState>(
  (ref) => RouteSettingNotifier(RouteSettingState()),
);

// A notifier that manaes the state of the screen according to the event that is dispatched to it
class RouteSettingNotifier extends StateNotifier<RouteSettingState> {
  RouteSettingNotifier(RouteSettingState state) : super(state);
}
