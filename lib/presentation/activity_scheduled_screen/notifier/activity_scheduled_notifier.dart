import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';
import '../../../data/services/mobility_api_service.dart';
import '../models/activity_scheduled_model.dart';
import '../models/scheduled_item_model.dart';

part 'activity_scheduled_state.dart';

final activityScheduledNotifier = StateNotifierProvider.autoDispose<
    ActivityScheduledNotifier, ActivityScheduledState>(
  (ref) => ActivityScheduledNotifier(
    ActivityScheduledState(
      activityScheduledModelObj: ActivityScheduledModel(),
      isLoading: true,
    ),
  ),
);

class ActivityScheduledNotifier extends StateNotifier<ActivityScheduledState> {
  ActivityScheduledNotifier(super.state);

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

      final items = <ScheduledItemModel>[
        ...rideRequests
            .where((item) => _scheduledRideStatuses.contains(item['status']))
            .map((item) => _mapRideRequest(item, rideMatches[item['id'].toString()])),
        ...deliveryRequests
            .where((item) => _scheduledDeliveryStatuses.contains(item['status']))
            .map((item) => _mapDeliveryRequest(item, deliveryMatches[item['id'].toString()])),
      ];

      items.sort(
        (left, right) =>
            _parseDate(left.scheduledAt).compareTo(_parseDate(right.scheduledAt)),
      );

      state = state.copyWith(
        isLoading: false,
        clearError: true,
        activityScheduledModelObj: ActivityScheduledModel(scheduledItemList: items),
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mobilityApiService.extractErrorMessage(error),
      );
    }
  }

  static const _scheduledRideStatuses = {'open', 'matched'};
  static const _scheduledDeliveryStatuses = {'open', 'matched'};

  ScheduledItemModel _mapRideRequest(
    Map<String, dynamic> request,
    Map<String, dynamic>? match,
  ) {
    final scheduledTime = request['scheduled_time']?.toString();
    return ScheduledItemModel(
      icon: ImageConstant.imgBlackCar,
      address:
          '${request['origin_name'] ?? 'Pickup'} to ${request['destination_name'] ?? 'Destination'}',
      pickupLocation: request['origin_name']?.toString(),
      destinationLocation: request['destination_name']?.toString(),
      date: _formatDateLabel(scheduledTime),
      time: _formatTimeLabel(scheduledTime),
      status: _formatStatus(request['status']?.toString()),
      moverName: _resolveMoverName(match, 'Finding a mover'),
      rating: _resolveSubtext(match, request['status']?.toString()),
      price: _resolvePrice(match),
      id: request['id']?.toString(),
      requestId: request['id']?.toString(),
      requestType: 'ride',
      scheduledAt: scheduledTime,
    );
  }

  ScheduledItemModel _mapDeliveryRequest(
    Map<String, dynamic> request,
    Map<String, dynamic>? match,
  ) {
    final scheduledTime = request['scheduled_time']?.toString();
    return ScheduledItemModel(
      icon: ImageConstant.imgPackageBlack,
      address:
          '${request['pickup_name'] ?? 'Pickup'} to ${request['dropoff_name'] ?? 'Dropoff'}',
      pickupLocation: request['pickup_name']?.toString(),
      destinationLocation: request['dropoff_name']?.toString(),
      date: _formatDateLabel(scheduledTime),
      time: _formatTimeLabel(scheduledTime),
      status: _formatStatus(request['status']?.toString()),
      moverName: _resolveMoverName(match, 'Finding a mover'),
      rating: _resolveSubtext(match, request['status']?.toString()),
      price: _resolvePrice(match),
      id: request['id']?.toString(),
      requestId: request['id']?.toString(),
      requestType: 'delivery',
      scheduledAt: scheduledTime,
    );
  }

  String _resolveMoverName(Map<String, dynamic>? match, String fallback) {
    final travelPlan = match?['travel_plan'];
    if (travelPlan is Map && travelPlan['created_by'] is Map) {
      final createdBy = travelPlan['created_by'] as Map;
      final fullName = createdBy['full_name']?.toString();
      if (fullName != null && fullName.isNotEmpty) {
        return fullName;
      }
    }
    return fallback;
  }

  String _resolveSubtext(Map<String, dynamic>? match, String? status) {
    if (match != null) {
      return 'Matched on your route';
    }
    if (status == 'matched') {
      return 'Mover assigned';
    }
    return 'Waiting for match confirmation';
  }

  String _resolvePrice(Map<String, dynamic>? match) {
    final agreedPrice = match?['agreed_price'];
    if (agreedPrice == null) {
      return 'Pending';
    }
    return 'NGN ${agreedPrice.toString()}';
  }

  String _formatStatus(String? rawStatus) {
    switch (rawStatus) {
      case 'matched':
        return 'Matched';
      case 'open':
        return 'Scheduled';
      default:
        return 'Scheduled';
    }
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
    return DateTime.tryParse(rawDate ?? '') ?? DateTime.now();
  }
}
