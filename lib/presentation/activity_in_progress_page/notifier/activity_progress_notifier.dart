import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/task_state_sync.dart';
import '../../../data/services/account_api_service.dart';
import '../../../data/services/mobility_api_service.dart';
import '../models/activity_in_progress_model.dart';
import '../models/activity_progress_tab_model.dart';
import '../models/progress_item_model.dart';

part 'activity_progress_state.dart';

final activityProgressNotifier = StateNotifierProvider.autoDispose<
    ActivityProgressNotifier, ActivityProgressState>(
  (ref) => ActivityProgressNotifier(
    ActivityProgressState(
      activityProgressTabModelObj: ActivityProgressTabModel(),
      isLoading: true,
    ),
  ),
);

class ActivityProgressNotifier extends StateNotifier<ActivityProgressState> {
  ActivityProgressNotifier(super.state) {
    _taskSyncSubscription = TaskStateSync.stream.listen((_) {
      unawaited(fetchActivities(silent: true));
    });
  }

  final AccountApiService _accountApiService = AccountApiService();
  final MobilityApiService _mobilityApiService = MobilityApiService();
  StreamSubscription<TaskStateSyncEvent>? _taskSyncSubscription;

  Future<void> fetchActivities({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      final responses = await Future.wait([
        _mobilityApiService.getMatches(),
        _accountApiService.getMe(),
      ]);

      final matches = List<Map<String, dynamic>>.from(responses[0] as List);
      final me = Map<String, dynamic>.from(responses[1] as Map);
      final user = Map<String, dynamic>.from(me['user'] as Map? ?? const {});
      final currentUserId = user['id']?.toString() ?? '';

      final items = matches
          .where(_shouldShowInActiveTab)
          .map((match) => _mapActiveMatch(match, currentUserId))
          .whereType<ProgressItemModel>()
          .toList();

      items.sort(
        (left, right) =>
            _parseDate(right.scheduledAt).compareTo(_parseDate(left.scheduledAt)),
      );

      state = state.copyWith(
        isLoading: false,
        clearError: true,
        activityProgressTabModelObj: ActivityProgressTabModel(progressList: items),
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mobilityApiService.extractErrorMessage(error),
      );
    }
  }

  ProgressItemModel? _mapActiveMatch(
    Map<String, dynamic> match,
    String currentUserId,
  ) {
    final rideRequest = match['ride_request'];
    if (rideRequest is Map) {
      return _mapRideMatch(
        Map<String, dynamic>.from(rideRequest),
        match,
        currentUserId,
      );
    }

    final deliveryRequest = match['delivery_request'];
    if (deliveryRequest is Map) {
      return _mapDeliveryMatch(
        Map<String, dynamic>.from(deliveryRequest),
        match,
        currentUserId,
      );
    }

    return null;
  }

  ProgressItemModel _mapRideMatch(
    Map<String, dynamic> request,
    Map<String, dynamic> match,
    String currentUserId,
  ) {
    final scheduledTime = request['scheduled_time']?.toString();
    final isMoverSide = _isMoverSide(match, currentUserId);
    final requester = Map<String, dynamic>.from(
      request['requester'] as Map? ?? const {},
    );
    final travelPlan = Map<String, dynamic>.from(
      match['travel_plan'] as Map? ?? const {},
    );
    final requestData = _buildRequestData(
      request: request,
      match: match,
      travelPlan: travelPlan,
      isMoverSide: isMoverSide,
    );

    return ProgressItemModel(
      icon: ImageConstant.imgBlackCar,
      address:
          '${request['origin_name'] ?? 'Pickup'} to ${request['destination_name'] ?? 'Destination'}',
      pickupLocation: request['origin_name']?.toString(),
      destinationLocation: request['destination_name']?.toString(),
      pickupLatitude: _toDouble(request['origin_latitude']),
      pickupLongitude: _toDouble(request['origin_longitude']),
      destinationLatitude: _toDouble(request['destination_latitude']),
      destinationLongitude: _toDouble(request['destination_longitude']),
      date: _formatDateLabel(scheduledTime),
      time: _formatTimeLabel(scheduledTime),
      status: 'In progress',
      moverName: isMoverSide
          ? _resolveFullName(requester, fallback: 'Passenger')
          : _resolveMoverName(match),
      rating: isMoverSide ? 'Passenger is on board' : 'Trip is in progress',
      price: _resolvePrice(match),
      id: request['id']?.toString(),
      requestId: request['id']?.toString(),
      requestType: 'ride',
      scheduledAt: scheduledTime,
      matchedTravelPlanId: _resolveTravelPlanId(request, match),
      matchId: match['id']?.toString(),
      isMoverSide: isMoverSide,
      requestData: requestData,
      matchStatus: match['status']?.toString(),
    );
  }

  ProgressItemModel _mapDeliveryMatch(
    Map<String, dynamic> request,
    Map<String, dynamic> match,
    String currentUserId,
  ) {
    final scheduledTime = request['scheduled_time']?.toString();
    final isMoverSide = _isMoverSide(match, currentUserId);
    final requester = Map<String, dynamic>.from(
      request['requester'] as Map? ?? const {},
    );
    final travelPlan = Map<String, dynamic>.from(
      match['travel_plan'] as Map? ?? const {},
    );
    final requestData = _buildRequestData(
      request: request,
      match: match,
      travelPlan: travelPlan,
      isMoverSide: isMoverSide,
    );
    final matchStatus = match['status']?.toString() ?? '';
    final isPickupPhase = !isMoverSide && matchStatus == 'accepted';

    return ProgressItemModel(
      icon: ImageConstant.imgPackageBlack,
      address:
          '${request['pickup_name'] ?? 'Pickup'} to ${request['dropoff_name'] ?? 'Dropoff'}',
      pickupLocation: request['pickup_name']?.toString(),
      destinationLocation: request['dropoff_name']?.toString(),
      pickupLatitude: _toDouble(request['pickup_latitude']),
      pickupLongitude: _toDouble(request['pickup_longitude']),
      destinationLatitude: _toDouble(request['dropoff_latitude']),
      destinationLongitude: _toDouble(request['dropoff_longitude']),
      date: _formatDateLabel(scheduledTime),
      time: _formatTimeLabel(scheduledTime),
      status: isPickupPhase ? 'Accepted' : 'In progress',
      moverName: isMoverSide
          ? _resolveFullName(requester, fallback: 'Customer')
          : _resolveMoverName(match),
      rating: isMoverSide
          ? 'Customer is waiting for delivery updates'
          : (isPickupPhase
              ? 'Mover is heading to the pickup location'
              : 'Your delivery will be delivered in 10 mins'),
      price: _resolvePrice(match),
      id: request['id']?.toString(),
      requestId: request['id']?.toString(),
      requestType: 'delivery',
      scheduledAt: scheduledTime,
      matchedTravelPlanId: _resolveTravelPlanId(request, match),
      matchId: match['id']?.toString(),
      isMoverSide: isMoverSide,
      requestData: requestData,
      matchStatus: matchStatus,
    );
  }

  String _resolveMoverName(Map<String, dynamic>? match) {
    final travelPlan = match?['travel_plan'];
    if (travelPlan is Map && travelPlan['created_by'] is Map) {
      final createdBy = Map<String, dynamic>.from(travelPlan['created_by'] as Map);
      return _resolveFullName(createdBy, fallback: 'Assigned mover');
    }
    return 'Assigned mover';
  }

  String _resolvePrice(Map<String, dynamic>? match) {
    final agreedPrice = match?['agreed_price'];
    if (agreedPrice == null) {
      return 'Pending';
    }
    return 'NGN ${agreedPrice.toString()}';
  }

  String _resolveTravelPlanId(
    Map<String, dynamic> request,
    Map<String, dynamic>? match,
  ) {
    final directPlanId = request['matched_plan']?.toString();
    if (directPlanId != null && directPlanId.isNotEmpty && directPlanId != 'null') {
      return directPlanId;
    }

    final travelPlan = match?['travel_plan'];
    if (travelPlan is Map && travelPlan['id'] != null) {
      return travelPlan['id'].toString();
    }

    return '';
  }

  Map<String, dynamic> _buildRequestData({
    required Map<String, dynamic> request,
    required Map<String, dynamic> match,
    required Map<String, dynamic> travelPlan,
    required bool isMoverSide,
  }) {
    return Map<String, dynamic>.from(request)
      ..['_match'] = match
      ..['_match_id'] = match['id']?.toString() ?? ''
      ..['_travel_plan'] = travelPlan
      ..['_is_mover_side'] = isMoverSide;
  }

  bool _isMoverSide(Map<String, dynamic> match, String currentUserId) {
    final travelPlan = match['travel_plan'];
    if (travelPlan is Map && travelPlan['created_by'] is Map) {
      final createdBy = Map<String, dynamic>.from(travelPlan['created_by'] as Map);
      final createdById = createdBy['id']?.toString() ?? '';
      if (createdById.isNotEmpty && currentUserId.isNotEmpty) {
        return createdById == currentUserId;
      }
    }

    final rideRequest = match['ride_request'];
    if (rideRequest is Map && rideRequest['requester'] is Map) {
      final requester = Map<String, dynamic>.from(rideRequest['requester'] as Map);
      final requesterId = requester['id']?.toString() ?? '';
      if (requesterId.isNotEmpty && currentUserId.isNotEmpty) {
        return requesterId != currentUserId;
      }
    }

    final deliveryRequest = match['delivery_request'];
    if (deliveryRequest is Map && deliveryRequest['requester'] is Map) {
      final requester = Map<String, dynamic>.from(deliveryRequest['requester'] as Map);
      final requesterId = requester['id']?.toString() ?? '';
      if (requesterId.isNotEmpty && currentUserId.isNotEmpty) {
        return requesterId != currentUserId;
      }
    }

    return false;
  }

  String _resolveFullName(
    Map<String, dynamic> person, {
    required String fallback,
  }) {
    final fullName = person['full_name']?.toString();
    if (fullName != null && fullName.trim().isNotEmpty) {
      return fullName.trim();
    }

    final firstName = person['first_name']?.toString() ?? '';
    final lastName = person['last_name']?.toString() ?? '';
    final combined = '$firstName $lastName'.trim();
    if (combined.isNotEmpty) {
      return combined;
    }

    final email = person['email']?.toString();
    if (email != null && email.isNotEmpty) {
      return email;
    }

    return fallback;
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

  bool _shouldShowInActiveTab(Map<String, dynamic> match) {
    final matchStatus = match['status']?.toString() ?? '';
    if (matchStatus == 'active') {
      return true;
    }

    if (matchStatus != 'accepted') {
      return false;
    }

    final matchType = match['match_type']?.toString() ?? 'delivery';
    return matchType == 'delivery';
  }

  double _toDouble(dynamic value) {
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
