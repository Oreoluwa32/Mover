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

  /// Toggle isLive status and call backend API
  Future<void> toggleIsLive(bool value, {String? routeId}) async {
    state = state.copyWith(isToggling: true);
    
    try {
      await _userApiService.toggleLiveStatus(
        routeId: routeId ?? '',
        isLive: value,
      );
      
      state = state.copyWith(
        isLive: value,
        showLiveNotification: true,
        isToggling: false,
      );
      
      await Future.delayed(const Duration(seconds: 3));
      state = state.copyWith(showLiveNotification: false);
    } catch (e) {
      state = state.copyWith(
        isLive: !value,
        isToggling: false,
      );
      rethrow;
    }
  }

  void setRouteCoordinates({
    required double locationLat,
    required double locationLng,
    required double destinationLat,
    required double destinationLng,
  }) {
    state = state.copyWith(
      highlightRoute: true,
      routeLocationLat: locationLat,
      routeLocationLng: locationLng,
      routeDestinationLat: destinationLat,
      routeDestinationLng: destinationLng,
    );
  }
}