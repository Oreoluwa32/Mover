import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/task_state_sync.dart';
import '../../../data/services/account_api_service.dart';
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
  ActivityScheduledNotifier(super.state) {
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
        _mobilityApiService.getRideRequests(),
        _mobilityApiService.getDeliveryRequests(),
        _mobilityApiService.getMatches(),
        _accountApiService.getMe(),
      ]);

      final rideRequests = List<Map<String, dynamic>>.from(responses[0] as List);
      final deliveryRequests = List<Map<String, dynamic>>.from(responses[1] as List);
      final matches = List<Map<String, dynamic>>.from(responses[2] as List);
      final me = Map<String, dynamic>.from(responses[3] as Map);
      final user = Map<String, dynamic>.from(me['user'] as Map? ?? const {});
      final currentUserId = user['id']?.toString() ?? '';

      final rideMatches = <String, Map<String, dynamic>>{};
      final deliveryMatches = <String, Map<String, dynamic>>{};
      final rideOffers = <String, List<Map<String, dynamic>>>{};
      final deliveryOffers = <String, List<Map<String, dynamic>>>{};

      for (final match in matches) {
        final rideRequest = match['ride_request'];
        if (rideRequest is Map && rideRequest['id'] != null) {
          final requestId = rideRequest['id'].toString();
          _storePreferredMatch(rideMatches, requestId, match);
          rideOffers.putIfAbsent(requestId, () => <Map<String, dynamic>>[]).add(match);
        }

        final deliveryRequest = match['delivery_request'];
        if (deliveryRequest is Map && deliveryRequest['id'] != null) {
          final requestId = deliveryRequest['id'].toString();
          _storePreferredMatch(
            deliveryMatches,
            requestId,
            match,
          );
          deliveryOffers
              .putIfAbsent(requestId, () => <Map<String, dynamic>>[])
              .add(match);
        }
      }

      final items = <ScheduledItemModel>[
        ...rideRequests
            .where((item) => _scheduledRideStatuses.contains(item['status']))
            .map(
              (item) => _mapRideRequest(
                item,
                rideMatches[item['id'].toString()],
                rideOffers[item['id'].toString()] ?? const <Map<String, dynamic>>[],
              ),
            ),
        ...deliveryRequests
            .where((item) => _scheduledDeliveryStatuses.contains(item['status']))
            .map(
              (item) => _mapDeliveryRequest(
                item,
                deliveryMatches[item['id'].toString()],
                deliveryOffers[item['id'].toString()] ?? const <Map<String, dynamic>>[],
              ),
            ),
        ...matches
            .where((match) => _shouldShowMoverScheduledMatch(match, currentUserId))
            .map(_mapMoverScheduledMatch)
            .whereType<ScheduledItemModel>(),
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

  static const _scheduledRideStatuses = {'open', 'matched', 'accepted'};
  static const _scheduledDeliveryStatuses = {'open', 'matched'};

  ScheduledItemModel _mapRideRequest(
    Map<String, dynamic> request,
    Map<String, dynamic>? match,
    List<Map<String, dynamic>> offers,
  ) {
    final scheduledTime = request['scheduled_time']?.toString();
    final hasAcceptedMover =
        offers.any((offer) => offer['status']?.toString() == 'accepted');
    final pricedOffers =
        offers.where((offer) => offer['agreed_price'] != null).toList();
    return ScheduledItemModel(
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
      status: _formatStatus(match?['status']?.toString() ?? request['status']?.toString()),
      moverName: _resolveMoverName(match, 'Finding a mover'),
      rating: _resolveSubtext(match, request['status']?.toString()),
      price: _resolvePrice(match),
      id: request['id']?.toString(),
      requestId: request['id']?.toString(),
      requestType: 'ride',
      scheduledAt: scheduledTime,
      hasPricedOffers: pricedOffers.isNotEmpty,
      hasAcceptedMover: hasAcceptedMover,
      offerCount: pricedOffers.length,
      requestData: request,
      matchId: match?['id']?.toString(),
      matchStatus: match?['status']?.toString() ?? request['status']?.toString(),
      isMoverSide: false,
    );
  }

  ScheduledItemModel _mapDeliveryRequest(
    Map<String, dynamic> request,
    Map<String, dynamic>? match,
    List<Map<String, dynamic>> offers,
  ) {
    final scheduledTime = request['scheduled_time']?.toString();
    final hasAcceptedMover =
        offers.any((offer) => offer['status']?.toString() == 'accepted');
    final pricedOffers =
        offers.where((offer) => offer['agreed_price'] != null).toList();
    return ScheduledItemModel(
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
      status: _formatStatus(match?['status']?.toString() ?? request['status']?.toString()),
      moverName: _resolveMoverName(match, 'Finding a mover'),
      rating: _resolveSubtext(match, request['status']?.toString()),
      price: _resolvePrice(match),
      id: request['id']?.toString(),
      requestId: request['id']?.toString(),
      requestType: 'delivery',
      scheduledAt: scheduledTime,
      hasPricedOffers: pricedOffers.isNotEmpty,
      hasAcceptedMover: hasAcceptedMover,
      offerCount: pricedOffers.length,
      requestData: request,
      matchId: match?['id']?.toString(),
      matchStatus: match?['status']?.toString() ?? request['status']?.toString(),
      isMoverSide: false,
    );
  }

  ScheduledItemModel? _mapMoverScheduledMatch(Map<String, dynamic> match) {
    final matchType = match['match_type']?.toString() ?? 'delivery';
    final matchStatus = match['status']?.toString() ?? '';
    final travelPlan = Map<String, dynamic>.from(
      match['travel_plan'] as Map? ?? const <String, dynamic>{},
    );

    if (matchType == 'ride') {
      final request = Map<String, dynamic>.from(
        match['ride_request'] as Map? ?? const <String, dynamic>{},
      );
      if (request.isEmpty) {
        return null;
      }

      final requester = Map<String, dynamic>.from(
        request['requester'] as Map? ?? const <String, dynamic>{},
      );
      final scheduledTime = request['scheduled_time']?.toString();
      final requestData = Map<String, dynamic>.from(request)
        ..['_match'] = match
        ..['_match_id'] = match['id']?.toString() ?? ''
        ..['_travel_plan'] = travelPlan
        ..['_is_mover_side'] = true;

      return ScheduledItemModel(
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
        status: _formatMoverScheduledStatus(matchStatus, matchType),
        moverName: _resolveFullName(requester, fallback: 'Passenger'),
        rating: _resolveMoverScheduledSubtext(matchStatus, matchType),
        price: _resolvePrice(match),
        id: match['id']?.toString(),
        requestId: request['id']?.toString(),
        requestType: 'ride',
        scheduledAt: scheduledTime,
        hasPricedOffers: true,
        hasAcceptedMover: matchStatus == 'accepted',
        offerCount: 1,
        requestData: requestData,
        matchId: match['id']?.toString(),
        matchStatus: matchStatus,
        isMoverSide: true,
      );
    }

    final request = Map<String, dynamic>.from(
      match['delivery_request'] as Map? ?? const <String, dynamic>{},
    );
    if (request.isEmpty) {
      return null;
    }

    final requester = Map<String, dynamic>.from(
      request['requester'] as Map? ?? const <String, dynamic>{},
    );
    final scheduledTime = request['scheduled_time']?.toString();
    final requestData = Map<String, dynamic>.from(request)
      ..['_match'] = match
      ..['_match_id'] = match['id']?.toString() ?? ''
      ..['_travel_plan'] = travelPlan
      ..['_is_mover_side'] = true;

    return ScheduledItemModel(
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
      status: _formatMoverScheduledStatus(matchStatus, matchType),
      moverName: _resolveFullName(requester, fallback: 'Customer'),
      rating: _resolveMoverScheduledSubtext(matchStatus, matchType),
      price: _resolvePrice(match),
      id: match['id']?.toString(),
      requestId: request['id']?.toString(),
      requestType: 'delivery',
      scheduledAt: scheduledTime,
      hasPricedOffers: true,
      hasAcceptedMover: matchStatus == 'accepted',
      offerCount: 1,
      requestData: requestData,
      matchId: match['id']?.toString(),
      matchStatus: matchStatus,
      isMoverSide: true,
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
    final matchStatus = match?['status']?.toString();
    if (matchStatus == 'accepted') {
      return 'Mover selected for your request';
    }
    if (matchStatus == 'proposed') {
      return 'Tap to pick a mover';
    }
    if (match != null) {
      return 'Matched on your route';
    }
    if (status == 'matched') {
      return 'Mover assigned';
    }
    return 'Waiting for match confirmation';
  }

  String _resolveMoverScheduledSubtext(String matchStatus, String matchType) {
    if (matchStatus == 'accepted') {
      return matchType == 'ride'
          ? 'Rider selected your fare'
          : 'Proceed to pickup when ready';
    }
    return 'Waiting for customer confirmation';
  }

  String _formatMoverScheduledStatus(String matchStatus, String matchType) {
    if (matchStatus == 'accepted' && matchType == 'ride') {
      return 'Accepted';
    }
    return 'Pending';
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
      case 'accepted':
        return 'Accepted';
      case 'matched':
        return 'Matched';
      case 'open':
        return 'Scheduled';
      default:
        return 'Scheduled';
    }
  }

  bool _shouldShowMoverScheduledMatch(
    Map<String, dynamic> match,
    String currentUserId,
  ) {
    if (currentUserId.isEmpty || !_isMoverSide(match, currentUserId)) {
      return false;
    }

    final matchStatus = match['status']?.toString() ?? '';
    final matchType = match['match_type']?.toString() ?? 'delivery';

    if (matchStatus == 'proposed') {
      return true;
    }

    if (matchStatus == 'accepted' && matchType == 'ride') {
      return true;
    }

    return false;
  }

  bool _isMoverSide(Map<String, dynamic> match, String currentUserId) {
    final travelPlan = match['travel_plan'];
    if (travelPlan is Map && travelPlan['created_by'] is Map) {
      final createdBy = Map<String, dynamic>.from(travelPlan['created_by'] as Map);
      return createdBy['id']?.toString() == currentUserId;
    }
    return false;
  }

  void _storePreferredMatch(
    Map<String, Map<String, dynamic>> target,
    String requestId,
    Map<String, dynamic> candidate,
  ) {
    final existing = target[requestId];
    if (existing == null ||
        _matchPriority(candidate['status']?.toString()) >
            _matchPriority(existing['status']?.toString())) {
      target[requestId] = candidate;
    }
  }

  int _matchPriority(String? status) {
    switch (status) {
      case 'accepted':
        return 4;
      case 'active':
        return 3;
      case 'proposed':
        return 2;
      case 'completed':
        return 1;
      default:
        return 0;
    }
  }

  @override
  void dispose() {
    _taskSyncSubscription?.cancel();
    super.dispose();
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

  double _toDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<void> removeScheduledActivity({
    required String requestId,
    required String requestType,
    required bool isMoverSide,
    String? matchId,
  }) async {
    try {
      if (isMoverSide) {
        if (matchId == null || matchId.isEmpty) {
          throw Exception('Task information is missing.');
        }
        await _mobilityApiService.cancelMatch(
          matchId: matchId,
          reason: 'Cancelled from scheduled activity',
        );
      } else {
        if (requestType == 'ride') {
          await _mobilityApiService.deleteRideRequest(requestId: requestId);
        } else {
          await _mobilityApiService.deleteDeliveryRequest(requestId: requestId);
        }
      }
      await fetchActivities();
    } catch (error) {
      throw Exception(_mobilityApiService.extractErrorMessage(error));
    }
  }

}
