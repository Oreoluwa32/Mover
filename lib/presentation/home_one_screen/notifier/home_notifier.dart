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
    try {
      // Set toggling state to prevent multiple simultaneous requests
      state = state.copyWith(isToggling: true);
      
      // Call backend API to toggle isLive status
      final response = await _userApiService.toggleLiveStatus(isLive: value);
      
      // Verify response status
      if (response['status'] == true) {
        // Update state after successful API call
        state = state.copyWith(
          isLive: response['is_live'] ?? value,
          showLiveNotification: true,
          isToggling: false,
        );
        
        print('✅ Live status toggled successfully: ${response['message']}');
        
        // Auto-hide notification after 3 seconds
        await Future.delayed(const Duration(seconds: 3));
        state = state.copyWith(showLiveNotification: false);
      } else {
        throw Exception(response['message'] ?? 'Failed to toggle live status');
      }
    } catch (e) {
      // On error, reset toggling state but keep the previous isLive value
      state = state.copyWith(isToggling: false);
      print('❌ Error toggling isLive status: $e');
      
      // Optionally show error notification
      state = state.copyWith(showLiveNotification: true);
      await Future.delayed(const Duration(seconds: 3));
      state = state.copyWith(showLiveNotification: false);
    }
  }
}