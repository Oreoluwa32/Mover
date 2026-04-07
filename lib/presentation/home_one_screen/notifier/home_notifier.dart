import 'dart:async';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/services/mobility_api_service.dart';
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
  late final MobilityApiService _mobilityApiService;
  Timer? _nearbyMoverSearchTimer;
  
  HomeNotifier(HomeState state) : super(state) {
    _userApiService = UserApiService();
    _mobilityApiService = MobilityApiService();
    loadLiveStatus();
    loadPendingTask();
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

  Future<void> loadLiveStatus() async {
    try {
      final response = await _userApiService.getLiveStatus();
      state = state.copyWith(
        isLive: response['is_live'] == true,
      );
    } catch (_) {
      state = state.copyWith(
        isLive: false,
      );
    }
  }

  Future<void> loadPendingTask() async {
    state = state.copyWith(isLoadingPendingTask: true);

    try {
      final latestPlan = await _mobilityApiService.getLatestTravelPlan();
      final planType = latestPlan?['plan_type']?.toString();
      final discoverDelivery = await _mobilityApiService.getDiscoverDeliveryRequests();
      final discoverRide = await _mobilityApiService.getDiscoverRideRequests();

      Map<String, dynamic>? pendingTask;
      String? pendingTaskType;

      if (planType == 'ride' && discoverRide.isNotEmpty) {
        pendingTask = discoverRide.first;
        pendingTaskType = 'ride';
      } else if (planType == 'delivery' && discoverDelivery.isNotEmpty) {
        pendingTask = discoverDelivery.first;
        pendingTaskType = 'delivery';
      } else if (discoverDelivery.isNotEmpty) {
        pendingTask = discoverDelivery.first;
        pendingTaskType = 'delivery';
      } else if (discoverRide.isNotEmpty) {
        pendingTask = discoverRide.first;
        pendingTaskType = 'ride';
      }

      state = state.copyWith(
        pendingTaskData: pendingTask,
        pendingTaskType: pendingTaskType,
        isLoadingPendingTask: false,
        clearPendingTask: pendingTask == null,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingPendingTask: false,
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

      await loadPendingTask();
      
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
    String? destinationName,
  }) {
    state = state.copyWith(
      highlightRoute: true,
      routeLocationLat: locationLat,
      routeLocationLng: locationLng,
      routeDestinationLat: destinationLat,
      routeDestinationLng: destinationLng,
      routeDestinationName: destinationName,
    );
  }

  void startNavigation() {
    state = state.copyWith(isNavigationActive: true);
  }

  void startNearbyMoverSearch({
    required String searchType,
    required Map<String, dynamic> searchData,
    Duration duration = const Duration(minutes: 3),
  }) {
    _nearbyMoverSearchTimer?.cancel();
    final endsAt = DateTime.now().add(duration);
    state = state.copyWith(
      isSearchingNearbyMovers: true,
      nearbyMoverSearchType: searchType,
      nearbyMoverSearchData: searchData,
      nearbyMoverSearchEndsAt: endsAt,
    );
    _nearbyMoverSearchTimer = Timer(duration, () {
      stopNearbyMoverSearch();
    });
  }

  void stopNearbyMoverSearch({bool clearSearch = false}) {
    _nearbyMoverSearchTimer?.cancel();
    state = state.copyWith(
      isSearchingNearbyMovers: false,
      clearNearbyMoverSearch: clearSearch,
    );
  }

  void stopNavigation() {
    state = state.copyWith(
      isNavigationActive: false,
      highlightRoute: false,
      routeLocationLat: null,
      routeLocationLng: null,
      routeDestinationLat: null,
      routeDestinationLng: null,
    );
  }

  @override
  void dispose() {
    _nearbyMoverSearchTimer?.cancel();
    super.dispose();
  }
}
