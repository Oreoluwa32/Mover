import 'dart:async';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../core/utils/task_state_sync.dart';
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
  Timer? _pendingTaskPollingTimer;
  StreamSubscription<TaskStateSyncEvent>? _taskSyncSubscription;
  
  HomeNotifier(HomeState state) : super(state) {
    _userApiService = UserApiService();
    _mobilityApiService = MobilityApiService();
    loadLiveStatus();
    loadPendingTask();
    _taskSyncSubscription = TaskStateSync.stream.listen((_) {
      unawaited(loadPendingTask(silent: true));
    });
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
      final isLive = response['is_live'] == true;
      state = state.copyWith(
        isLive: isLive,
      );
      _syncPendingTaskPolling(isLive);
    } catch (_) {
      state = state.copyWith(
        isLive: false,
      );
      _syncPendingTaskPolling(false);
    }
  }

  Future<void> loadPendingTask({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(isLoadingPendingTask: true);
    }

    try {
      final latestPlan = await _mobilityApiService.getLatestTravelPlan();
      final latestPlanId = latestPlan?['id']?.toString();
      final planType = latestPlan?['plan_type']?.toString();
      final responses = await Future.wait([
        _mobilityApiService.getMatches(),
        _mobilityApiService.getDiscoverDeliveryRequests(),
        _mobilityApiService.getDiscoverRideRequests(),
      ]);
      final matches = List<Map<String, dynamic>>.from(responses[0] as List);
      final discoverDelivery = List<Map<String, dynamic>>.from(responses[1] as List);
      final discoverRide = List<Map<String, dynamic>>.from(responses[2] as List);

      Map<String, dynamic>? pendingTask;
      String? pendingTaskType;
      String? pendingTaskPhase;

      final moverMatch = _resolveMoverMatch(
        matches: matches,
        latestPlanId: latestPlanId,
      );

      if (moverMatch != null) {
        pendingTask = _buildMoverTaskPayload(moverMatch);
        pendingTaskType = moverMatch['match_type']?.toString();
        pendingTaskPhase = moverMatch['status']?.toString() == 'active'
            ? 'active'
            : 'accepted';
      }

      if (pendingTask == null && planType == 'ride' && discoverRide.isNotEmpty) {
        pendingTask = discoverRide.first;
        pendingTaskType = 'ride';
        pendingTaskPhase = 'open';
      } else if (pendingTask == null &&
          planType == 'delivery' &&
          discoverDelivery.isNotEmpty) {
        pendingTask = discoverDelivery.first;
        pendingTaskType = 'delivery';
        pendingTaskPhase = 'open';
      } else if (pendingTask == null && discoverDelivery.isNotEmpty) {
        pendingTask = discoverDelivery.first;
        pendingTaskType = 'delivery';
        pendingTaskPhase = 'open';
      } else if (pendingTask == null && discoverRide.isNotEmpty) {
        pendingTask = discoverRide.first;
        pendingTaskType = 'ride';
        pendingTaskPhase = 'open';
      }

      state = state.copyWith(
        pendingTaskData: pendingTask,
        pendingTaskType: pendingTaskType,
        pendingTaskPhase: pendingTaskPhase,
        isLoadingPendingTask: false,
        clearPendingTask: pendingTask == null,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingPendingTask: false,
      );
    }
  }

  Map<String, dynamic>? _resolveMoverMatch({
    required List<Map<String, dynamic>> matches,
    required String? latestPlanId,
  }) {
    if (latestPlanId == null || latestPlanId.isEmpty) {
      return null;
    }

    final relevantMatches = matches.where((match) {
      final travelPlan =
          Map<String, dynamic>.from(match['travel_plan'] as Map? ?? const {});
      final matchPlanId = travelPlan['id']?.toString();
      final status = match['status']?.toString();
      return matchPlanId == latestPlanId &&
          (status == 'accepted' || status == 'active');
    }).toList()
      ..sort((left, right) =>
          _matchPriority(right['status']?.toString())
              .compareTo(_matchPriority(left['status']?.toString())));

    if (relevantMatches.isEmpty) {
      return null;
    }

    return relevantMatches.first;
  }

  Map<String, dynamic> _buildMoverTaskPayload(Map<String, dynamic> match) {
    final requestType = match['match_type']?.toString() ?? 'delivery';
    final request = Map<String, dynamic>.from(
      requestType == 'ride'
          ? match['ride_request'] as Map? ?? const <String, dynamic>{}
          : match['delivery_request'] as Map? ?? const <String, dynamic>{},
    );
    request['_match_id'] = match['id']?.toString();
    request['_match_status'] = match['status']?.toString();
    request['_travel_plan'] =
        Map<String, dynamic>.from(match['travel_plan'] as Map? ?? const {});
    request['_match'] = match;
    return request;
  }

  int _matchPriority(String? status) {
    switch (status) {
      case 'active':
        return 2;
      case 'accepted':
        return 1;
      default:
        return 0;
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
      _syncPendingTaskPolling(value);

      await loadPendingTask();
      
      await Future.delayed(const Duration(seconds: 3));
      state = state.copyWith(showLiveNotification: false);
    } catch (e) {
      state = state.copyWith(
        isLive: !value,
        isToggling: false,
      );
      _syncPendingTaskPolling(!value);
      rethrow;
    }
  }

  Future<void> enableLiveIfNeeded({String? routeId}) async {
    if (state.isLive || state.isToggling) {
      return;
    }

    try {
      await toggleIsLive(true, routeId: routeId);
    } catch (_) {
      // Some instant requester flows do not create a route first.
      // Keep the app usable without surfacing a blocking error here.
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

  void clearRouteHighlight() {
    state = state.copyWith(
      highlightRoute: false,
      routeLocationLat: null,
      routeLocationLng: null,
      routeDestinationLat: null,
      routeDestinationLng: null,
      routeDestinationName: null,
    );
  }

  Future<void> cancelPendingTask({
    String? reason,
    String? details,
  }) async {
    final pendingTask = state.pendingTaskData;
    final matchId = pendingTask?['_match_id']?.toString();
    if (matchId == null || matchId.isEmpty) {
      throw Exception('No assigned task found to cancel.');
    }

    await _mobilityApiService.cancelMatch(
      matchId: matchId,
      reason: reason,
      details: details,
    );
    clearRouteHighlight();
    state = state.copyWith(clearPendingTask: true);
    await loadPendingTask();
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
      nearbyMovers: const <Map<String, dynamic>>[],
      nearbyMoverLastUpdatedAt: null,
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

  void updateNearbyMoverResults({
    required List<Map<String, dynamic>> movers,
    required DateTime updatedAt,
  }) {
    state = state.copyWith(
      nearbyMovers: movers,
      nearbyMoverLastUpdatedAt: updatedAt,
    );
  }

  void _syncPendingTaskPolling(bool isLive) {
    _pendingTaskPollingTimer?.cancel();
    if (!isLive) {
      state = state.copyWith(clearPendingTask: true);
      return;
    }

    unawaited(loadPendingTask());
    _pendingTaskPollingTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        unawaited(loadPendingTask());
      },
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
    _pendingTaskPollingTimer?.cancel();
    _taskSyncSubscription?.cancel();
    super.dispose();
  }
}
