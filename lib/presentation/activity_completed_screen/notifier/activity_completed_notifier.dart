import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/task_state_sync.dart';
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
  ActivityCompletedNotifier(super.state) {
    _taskSyncSubscription = TaskStateSync.stream.listen((_) {
      unawaited(fetchActivities(silent: true));
    });
  }

  final MobilityApiService _mobilityApiService = MobilityApiService();
  StreamSubscription<TaskStateSyncEvent>? _taskSyncSubscription;

  Future<void> fetchActivities({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      final matches = await _mobilityApiService.getMatches();

      final items = matches
          .where((match) => match['status']?.toString() == 'completed')
          .map(_mapCompletedMatch)
          .whereType<CompletedItemModel>()
          .toList();

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

  CompletedItemModel? _mapCompletedMatch(Map<String, dynamic> match) {
    final rideRequest = Map<String, dynamic>.from(
      match['ride_request'] as Map? ?? const <String, dynamic>{},
    );
    final deliveryRequest = Map<String, dynamic>.from(
      match['delivery_request'] as Map? ?? const <String, dynamic>{},
    );
    final travelPlan = Map<String, dynamic>.from(
      match['travel_plan'] as Map? ?? const <String, dynamic>{},
    );
    final requestType = match['match_type']?.toString();

    if (requestType == 'ride' && rideRequest.isNotEmpty) {
      final scheduledTime = rideRequest['scheduled_time']?.toString();
      final enrichedRequest = Map<String, dynamic>.from(rideRequest)
        ..['_match'] = match
        ..['_match_id'] = match['id']?.toString() ?? ''
        ..['_travel_plan'] = travelPlan;
      return CompletedItemModel(
        icon: ImageConstant.imgBlackCar,
        address:
            '${rideRequest['origin_name'] ?? 'Pickup'} to ${rideRequest['destination_name'] ?? 'Destination'}',
        pickupLocation: rideRequest['origin_name']?.toString(),
        destinationLocation: rideRequest['destination_name']?.toString(),
        pickupLatitude: _safeDouble(rideRequest['origin_latitude']),
        pickupLongitude: _safeDouble(rideRequest['origin_longitude']),
        destinationLatitude: _safeDouble(rideRequest['destination_latitude']),
        destinationLongitude: _safeDouble(rideRequest['destination_longitude']),
        date: _formatDateLabel(scheduledTime),
        time: _formatTimeLabel(scheduledTime),
        status: 'Completed',
        moverName: _resolveMoverName(match),
        rating: 'Trip completed',
        price: _resolvePrice(match),
        id: match['id']?.toString(),
        requestId: rideRequest['id']?.toString(),
        requestType: 'ride',
        scheduledAt: scheduledTime,
        requestData: enrichedRequest,
      );
    }

    if (requestType == 'delivery' && deliveryRequest.isNotEmpty) {
      final scheduledTime = deliveryRequest['scheduled_time']?.toString();
      final enrichedRequest = Map<String, dynamic>.from(deliveryRequest)
        ..['_match'] = match
        ..['_match_id'] = match['id']?.toString() ?? ''
        ..['_travel_plan'] = travelPlan;
      return CompletedItemModel(
        icon: ImageConstant.imgPackageBlack,
        address:
            '${deliveryRequest['pickup_name'] ?? 'Pickup'} to ${deliveryRequest['dropoff_name'] ?? 'Dropoff'}',
        pickupLocation: deliveryRequest['pickup_name']?.toString(),
        destinationLocation: deliveryRequest['dropoff_name']?.toString(),
        pickupLatitude: _safeDouble(deliveryRequest['pickup_latitude']),
        pickupLongitude: _safeDouble(deliveryRequest['pickup_longitude']),
        destinationLatitude: _safeDouble(deliveryRequest['dropoff_latitude']),
        destinationLongitude: _safeDouble(deliveryRequest['dropoff_longitude']),
        date: _formatDateLabel(scheduledTime),
        time: _formatTimeLabel(scheduledTime),
        status: 'Completed',
        moverName: _resolveMoverName(match),
        rating: 'Delivery completed',
        price: _resolvePrice(match),
        id: match['id']?.toString(),
        requestId: deliveryRequest['id']?.toString(),
        requestType: 'delivery',
        scheduledAt: scheduledTime,
        requestData: enrichedRequest,
      );
    }

    return null;
  }

  String _resolveMoverName(Map<String, dynamic> match) {
    final travelPlan = Map<String, dynamic>.from(
      match['travel_plan'] as Map? ?? const <String, dynamic>{},
    );
    final mover = Map<String, dynamic>.from(
      travelPlan['created_by'] as Map? ?? const <String, dynamic>{},
    );
    final moverName = mover['full_name']?.toString().trim() ?? '';
    if (moverName.isNotEmpty) {
      return moverName;
    }
    return 'Completed request';
  }

  String _resolvePrice(Map<String, dynamic> match) {
    final agreedPrice = match['agreed_price'];
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

  double _safeDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  void dispose() {
    _taskSyncSubscription?.cancel();
    super.dispose();
  }
}
