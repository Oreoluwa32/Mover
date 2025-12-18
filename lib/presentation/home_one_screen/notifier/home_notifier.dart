import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/services/user_api_service.dart';
import '../models/home_initial_model.dart';
import '../models/home_model.dart';
part 'home_state.dart';

final homeNotifier = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(HomeState(
    isSelectedSwitch: false,
    homeInitialModelObj: HomeInitialModel()
  )),
);

// A notifier that manages the state of the home screen according to the event that is dispatched to it
class HomeNotifier extends StateNotifier<HomeState>{
  late final UserApiService _userApiService;
  
  HomeNotifier(HomeState state) : super(state) {
    _userApiService = UserApiService();
  }

  void changeSwitchBox(bool value) {
    state = state.copyWith(
      isSelectedSwitch: value,
    );
    if (value == false) {
      Text(
        "OFF",
      );
    } else {
      Text(
        "ON",
      );
    }
  }

  /// Toggle isLive status and show temporary notification
  Future<void> toggleIsLive(bool value) async {
    state = state.copyWith(
      isLive: value,
      showLiveNotification: true,
    );
    
    await Future.delayed(const Duration(seconds: 3));
    state = state.copyWith(showLiveNotification: false);
  }
}