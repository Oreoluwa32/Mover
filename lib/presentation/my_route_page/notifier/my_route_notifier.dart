import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/my_route_model.dart';
import '../models/saved_route_model.dart';
part 'my_route_state.dart';

final myRouteNotifier =
    StateNotifierProvider.autoDispose<MyRouteNotifier, MyRouteState>(
  (ref) => MyRouteNotifier(MyRouteState(
      myRouteModelObj: MyRouteModel(savedrouteItemList: [
    SavedRouteModel(
        routetitle: "Work Route",
        islive: "Live",
        address: "Gateway Zone, Magodo Phase II, GRA Lagos State",
        time: "7:30AM",
        days: "Mon - Fri"),
    SavedRouteModel(
        address: "Gateway Zone, Magodo Phase II, GRA Lagos State",
        time: "7:30AM",
        days: "Mon - Fri"),
    SavedRouteModel(
        address: "Gateway Zone, Magodo Phase II, GRA Lagos State",
        time: "7:30AM",
        days: "Mon - Fri"),
    SavedRouteModel(
        address: "Gateway Zone, Magodo Phase II, GRA Lagos State",
        time: "7:30AM",
        days: "Mon - Fri"),
    SavedRouteModel(
        address: "Gateway Zone, Magodo Phase II, GRA Lagos State",
        time: "7:30AM",
        days: "Mon - Fri"),
  ]))),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class MyRouteNotifier extends StateNotifier<MyRouteState> {
  MyRouteNotifier(MyRouteState state) : super(state);
}
