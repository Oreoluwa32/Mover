import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';
import '../../../data/services/mobility_api_service.dart';
import '../models/activity_completed_model.dart';
import '../models/completed_item_model.dart';

part 'activity_completed_state.dart';

final activityCompletedNotifier = StateNotifierProvider.autoDispose<
    ActivityCompletedNotifier, ActivityCompletedState>(
  (ref) => ActivityCompletedNotifier(
    ActivityCompletedState(
      activityCompletedModelObj: ActivityCompletedModel(),
      isLoading: true,
    ),
  ),
);

class ActivityCompletedNotifier extends StateNotifier<ActivityCompletedState> {
  ActivityCompletedNotifier(super.state);

  final MobilityApiService _mobilityApiService = MobilityApiService();

  Future<void> fetchActivities() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final responses = await Future.wait([
        _mobilityApiService.getRideRequests(),
        _mobilityApiService.getDeliveryRequests(),
        _mobilityApiService.getMatches(),
      ]);

      final rideRequests = List<Map<String, dynamic>>.from(responses[0] as List);
      final deliveryRequests = List<Map<String, dynamic>>.from(responses[1] as List);
      final matches = List<Map<String, dynamic>>.from(responses[2] as List);

      final rideMatches = <String, Map<String, dynamic>>{};
      final deliveryMatches = <String, Map<String, dynamic>>{};

      for (final match in matches) {
        final rideRequest = match['ride_request'];
        if (rideRequest is Map && rideRequest['id'] != null) {
          rideMatches[rideRequest['id'].toString()] = match;
        }

        final deliveryRequest = match['delivery_request'];
        if (deliveryRequest is Map && deliveryRequest['id'] != null) {
          deliveryMatches[deliveryRequest['id'].toString()] = match;
        }
      }

      final items = <CompletedItemModel>[
        ...rideRequests
            .where((item) => item['status'] == 'completed')
            .map((item) => _mapRideRequest(item, rideMatches[item['id'].toString()])),
        ...deliveryRequests
            .where((item) => item['status'] == 'delivered')
            .map((item) => _mapDeliveryRequest(item, deliveryMatches[item['id'].toString()])),
      ];

      items.sort(
        (left, right) =>
            _parseDate(right.scheduledAt).compareTo(_parseDate(left.scheduledAt)),
      );

      state = state.copyWith(
        isLoading: false,
        clearError: true,
        activityCompletedModelObj: ActivityCompletedModel(completedItemList: items),
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mobilityApiService.extractErrorMessage(error),
      );
    }
  }

  CompletedItemModel _mapRideRequest(
    Map<String, dynamic> request,
    Map<String, dynamic>? match,
  ) {
    final scheduledTime = request['scheduled_time']?.toString();
    return CompletedItemModel(
      icon: ImageConstant.imgBlackCar,
      address:
          '${request['origin_name'] ?? 'Pickup'} to ${request['destination_name'] ?? 'Destination'}',
      pickupLocation: request['origin_name']?.toString(),
      destinationLocation: request['destination_name']?.toString(),
      date: _formatDateLabel(scheduledTime),
      time: _formatTimeLabel(scheduledTime),
      status: 'Completed',
      moverName: _resolveMoverName(match),
      rating: 'Trip completed',
      price: _resolvePrice(match),
      id: request['id']?.toString(),
      requestId: request['id']?.toString(),
      requestType: 'ride',
      scheduledAt: scheduledTime,
    );
  }

  CompletedItemModel _mapDeliveryRequest(
    Map<String, dynamic> request,
    Map<String, dynamic>? match,
  ) {
    final scheduledTime = request['scheduled_time']?.toString();
    return CompletedItemModel(
      icon: ImageConstant.imgPackageBlack,
      address:
          '${request['pickup_name'] ?? 'Pickup'} to ${request['dropoff_name'] ?? 'Dropoff'}',
      pickupLocation: request['pickup_name']?.toString(),
      destinationLocation: request['dropoff_name']?.toString(),
      date: _formatDateLabel(scheduledTime),
      time: _formatTimeLabel(scheduledTime),
      status: 'Completed',
      moverName: _resolveMoverName(match),
      rating: 'Delivery completed',
      price: _resolvePrice(match),
      id: request['id']?.toString(),
      requestId: request['id']?.toString(),
      requestType: 'delivery',
      scheduledAt: scheduledTime,
    );
  }

  String _resolveMoverName(Map<String, dynamic>? match) {
    final travelPlan = match?['travel_plan'];
    if (travelPlan is Map && travelPlan['created_by'] is Map) {
      final createdBy = travelPlan['created_by'] as Map;
      final fullName = createdBy['full_name']?.toString();
      if (fullName != null && fullName.isNotEmpty) {
        return fullName;
      }
    }
    return 'Completed request';
  }

  String _resolvePrice(Map<String, dynamic>? match) {
    final agreedPrice = match?['agreed_price'];
    if (agreedPrice == null) {
      return 'Pending';
    }
    return 'NGN ${agreedPrice.toString()}';
  }

  String _formatDateLabel(String? rawDate) {
    final parsed = DateTime.tryParse(rawDate ?? '');
    if (parsed == null) {
      return 'TBD';
    }
    return DateFormat('dd MMM').format(parsed.toLocal());
  }

  String _formatTimeLabel(String? rawDate) {
    final parsed = DateTime.tryParse(rawDate ?? '');
    if (parsed == null) {
      return '--:--';
    }
    return DateFormat('h:mm a').format(parsed.toLocal());
  }

  DateTime _parseDate(String? rawDate) {
    return DateTime.tryParse(rawDate ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
  }
}
