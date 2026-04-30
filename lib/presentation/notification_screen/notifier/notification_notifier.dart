import 'dart:async';

import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../core/utils/task_state_sync.dart';
import '../../../data/services/account_api_service.dart';
import '../../../data/services/mobility_api_service.dart';
import '../../../data/services/wallet_api_service.dart';
import '../models/list_item_model.dart';
import '../models/notification_model.dart';
part 'notification_state.dart';

final notificationNotifier =
    StateNotifierProvider.autoDispose<NotificationNotifier, NotificationState>(
  (ref) => NotificationNotifier(
    NotificationState(
      notificationModelObj: NotificationModel(),
    ),
  ),
);

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier(NotificationState state) : super(state) {
    unawaited(refreshNotifications());
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 20),
      (_) => unawaited(refreshNotifications(silent: true)),
    );
    _taskSyncSubscription = TaskStateSync.stream.listen((_) {
      unawaited(refreshNotifications(silent: true));
    });
  }

  final MobilityApiService _mobilityApiService = MobilityApiService();
  final AccountApiService _accountApiService = AccountApiService();
  final WalletApiService _walletApiService = WalletApiService();
  final PrefUtils _prefUtils = PrefUtils();
  Timer? _pollingTimer;
  StreamSubscription<TaskStateSyncEvent>? _taskSyncSubscription;
  String? _currentUserId;

  Future<void> refreshNotifications({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      await _prefUtils.init();
      final currentUserId = await _resolveCurrentUserId();
      if (currentUserId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          unreadCount: 0,
          notificationModelObj: NotificationModel(),
        );
        return;
      }

      final matches = await _mobilityApiService.getMatches();
      final walletData = await _walletApiService.fetchWalletData();
      final taskNotifications = matches
          .map((match) => _mapMatchToNotification(match, currentUserId))
          .whereType<ListItemModel>()
          .toList();
      final walletNotifications = (walletData.transactions ?? const [])
          .map(_mapWalletTransactionToNotification)
          .whereType<ListItemModel>()
          .toList();
      final notifications = <ListItemModel>[
        ...taskNotifications,
        ...walletNotifications,
      ]..sort(
          (left, right) =>
              _parseDate(right.createdAt).compareTo(_parseDate(left.createdAt)),
        );

      final lastSeenAt = await _prefUtils.getNotificationLastSeenAt();
      final normalized = notifications
          .map(
            (item) => item.copyWith(
              isRead: lastSeenAt != null &&
                  _parseDate(item.createdAt)
                      .isBefore(lastSeenAt.add(const Duration(seconds: 1))),
            ),
          )
          .toList();

      state = state.copyWith(
        isLoading: false,
        unreadCount: normalized.where((item) => item.isRead != true).length,
        notificationModelObj: NotificationModel(listItemList: normalized),
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mobilityApiService.extractErrorMessage(error),
      );
    }
  }

  Future<void> markAllAsRead() async {
    await _prefUtils.init();
    await _prefUtils
        .setNotificationLastSeenAt(DateTime.now().toIso8601String());
    final currentItems =
        state.notificationModelObj?.listItemList ?? const <ListItemModel>[];
    state = state.copyWith(
      unreadCount: 0,
      notificationModelObj: NotificationModel(
        listItemList:
            currentItems.map((item) => item.copyWith(isRead: true)).toList(),
      ),
    );
  }

  Future<String> _resolveCurrentUserId() async {
    if (_currentUserId != null && _currentUserId!.isNotEmpty) {
      return _currentUserId!;
    }
    final me = await _accountApiService.getMe();
    final user = Map<String, dynamic>.from(
      me['user'] as Map? ?? const <String, dynamic>{},
    );
    _currentUserId = user['id']?.toString() ?? '';
    return _currentUserId ?? '';
  }

  ListItemModel? _mapMatchToNotification(
    Map<String, dynamic> match,
    String currentUserId,
  ) {
    final status = match['status']?.toString() ?? '';
    final matchType = match['match_type']?.toString() ?? 'delivery';
    final travelPlan = Map<String, dynamic>.from(
      match['travel_plan'] as Map? ?? const <String, dynamic>{},
    );
    final mover = Map<String, dynamic>.from(
      travelPlan['created_by'] as Map? ?? const <String, dynamic>{},
    );
    final rideRequest = Map<String, dynamic>.from(
      match['ride_request'] as Map? ?? const <String, dynamic>{},
    );
    final deliveryRequest = Map<String, dynamic>.from(
      match['delivery_request'] as Map? ?? const <String, dynamic>{},
    );
    final request = matchType == 'ride' ? rideRequest : deliveryRequest;
    final requester = Map<String, dynamic>.from(
      request['requester'] as Map? ?? const <String, dynamic>{},
    );

    final isMover = mover['id']?.toString() == currentUserId;
    final isRequester = requester['id']?.toString() == currentUserId;
    if (!isMover && !isRequester) {
      return null;
    }

    final titleMessage = _buildLifecycleCopy(
      matchType: matchType,
      status: status,
      isMover: isMover,
      moverName: mover['full_name']?.toString(),
      requesterName: requester['full_name']?.toString(),
      routeLabel: _buildRouteLabel(matchType: matchType, request: request),
      cancellationReason: _resolveCancellationReason(match, request),
    );
    if (titleMessage == null) {
      return null;
    }

    final createdAt =
        _resolveEventDate(match: match, request: request, status: status);

    return ListItemModel(
      id: '${match['id'] ?? ''}:$status',
      createdAt: createdAt.toIso8601String(),
      time: _formatTime(createdAt),
      title: titleMessage.$1,
      message: titleMessage.$2,
      actionType: _buildActionType(
        status: status,
        matchType: matchType,
        isMover: isMover,
      ),
      actionArguments: _buildActionArguments(
        match: match,
        request: request,
        matchType: matchType,
        isMover: isMover,
      ),
    );
  }

  ListItemModel? _mapWalletTransactionToNotification(transaction) {
    final type = (transaction.type ?? '').toLowerCase();
    final status = (transaction.status ?? '').toLowerCase();
    if (type != 'deposit' || status != 'success') {
      return null;
    }

    final relatedType = (transaction.relatedType ?? '').toLowerCase();
    final description = (transaction.description ?? '').trim();
    final isWalletTopUp = relatedType == 'wallet_top_up' ||
        description.toLowerCase().contains('wallet funding');
    if (!isWalletTopUp) {
      return null;
    }

    final createdAt = transaction.createdAt ?? transaction.date ?? '';
    final createdAtValue = _parseDate(createdAt);
    final amountValue = double.tryParse(transaction.amount ?? '0') ?? 0;
    final amountLabel = amountValue.toStringAsFixed(2);

    return ListItemModel(
      id: 'wallet:${transaction.reference ?? transaction.id ?? createdAt}',
      createdAt: createdAtValue.toIso8601String(),
      time: _formatTime(createdAtValue),
      title: 'Wallet funded',
      message:
          'Your wallet has been credited with NGN $amountLabel successfully.',
      actionType: 'wallet_history',
      actionArguments: <String, dynamic>{
        'reference': transaction.reference,
        'amount': amountValue,
      },
    );
  }

  String _buildActionType({
    required String status,
    required String matchType,
    required bool isMover,
  }) {
    switch (status) {
      case 'proposed':
        return isMover ? '' : 'hire_mover';
      case 'accepted':
        if (!isMover) {
          return '';
        }
        return matchType == 'delivery'
            ? 'mover_delivery_pickup'
            : 'mover_ride_waiting';
      case 'active':
        if (matchType == 'delivery') {
          return isMover
              ? 'mover_delivery_active'
              : 'requester_delivery_active';
        }
        return isMover ? 'mover_ride_active' : 'requester_ride_active';
      case 'completed':
        return 'completed_task';
      default:
        return '';
    }
  }

  Map<String, dynamic> _buildActionArguments({
    required Map<String, dynamic> match,
    required Map<String, dynamic> request,
    required String matchType,
    required bool isMover,
  }) {
    final travelPlan = Map<String, dynamic>.from(
      match['travel_plan'] as Map? ?? const <String, dynamic>{},
    );
    final enrichedRequest = Map<String, dynamic>.from(request)
      ..['_match'] = match
      ..['_match_id'] = match['id']?.toString()
      ..['_travel_plan'] = travelPlan
      ..['_is_mover_side'] = isMover;
    final scheduledTime = request['scheduled_time']?.toString();
    final moverName = _resolveFullName(
      Map<String, dynamic>.from(
        travelPlan['created_by'] as Map? ?? const <String, dynamic>{},
      ),
      fallback: 'Assigned mover',
    );

    return {
      'requestId': request['id']?.toString(),
      'requestType': matchType,
      'pickupLocation': matchType == 'ride'
          ? request['origin_name']?.toString()
          : request['pickup_name']?.toString(),
      'destinationLocation': matchType == 'ride'
          ? request['destination_name']?.toString()
          : request['dropoff_name']?.toString(),
      'date': _formatDateLabel(scheduledTime),
      'time': _formatTimeLabel(scheduledTime),
      'status': _buildStatusLabel(match['status']?.toString(), matchType),
      'moverName': isMover
          ? _resolveFullName(
              Map<String, dynamic>.from(
                request['requester'] as Map? ?? const <String, dynamic>{},
              ),
              fallback: matchType == 'ride' ? 'Passenger' : 'Customer',
            )
          : moverName,
      'rating': _buildRatingLabel(
        status: match['status']?.toString() ?? '',
        matchType: matchType,
        isMover: isMover,
      ),
      'price': match['agreed_price']?.toString() ?? '',
      'travelPlanId': travelPlan['id']?.toString() ?? '',
      'matchId': match['id']?.toString() ?? '',
      'matchStatus': match['status']?.toString() ?? '',
      'requestData': enrichedRequest,
      'taskPhase':
          match['status']?.toString() == 'active' ? 'active' : 'accepted',
      'pickupLatitude': _safeDouble(
        matchType == 'ride'
            ? request['origin_latitude']
            : request['pickup_latitude'],
      ),
      'pickupLongitude': _safeDouble(
        matchType == 'ride'
            ? request['origin_longitude']
            : request['pickup_longitude'],
      ),
      'destinationLatitude': _safeDouble(
        matchType == 'ride'
            ? request['destination_latitude']
            : request['dropoff_latitude'],
      ),
      'destinationLongitude': _safeDouble(
        matchType == 'ride'
            ? request['destination_longitude']
            : request['dropoff_longitude'],
      ),
      'paymentMode': 'Wallet',
    };
  }

  (String, String)? _buildLifecycleCopy({
    required String matchType,
    required String status,
    required bool isMover,
    required String? moverName,
    required String? requesterName,
    required String routeLabel,
    required String cancellationReason,
  }) {
    final taskLabel = matchType == 'ride' ? 'ride' : 'delivery';
    final moverDisplay =
        (moverName?.trim().isNotEmpty == true) ? moverName!.trim() : 'A mover';
    final requesterDisplay = (requesterName?.trim().isNotEmpty == true)
        ? requesterName!.trim()
        : 'A customer';

    switch (status) {
      case 'proposed':
        if (isMover) {
          return null;
        }
        return (
          'New price received',
          '$moverDisplay sent a price for your $taskLabel request on $routeLabel.',
        );
      case 'accepted':
        if (isMover) {
          return (
            'Task selected',
            '$requesterDisplay selected your $taskLabel offer for $routeLabel.',
          );
        }
        return null;
      case 'active':
        if (matchType == 'delivery') {
          return isMover
              ? (
                  'Delivery in progress',
                  'Your delivery to $routeLabel is now in transit.',
                )
              : (
                  'Delivery in progress',
                  '$moverDisplay picked up your item and is on the way to $routeLabel.',
                );
        }
        return isMover
            ? (
                'Ride in progress',
                'Your trip with $requesterDisplay is now active on $routeLabel.',
              )
            : (
                'Ride started',
                '$moverDisplay has started your trip on $routeLabel.',
              );
      case 'completed':
        return isMover
            ? (
                matchType == 'delivery'
                    ? 'Delivery completed'
                    : 'Ride completed',
                'Your $taskLabel task on $routeLabel has been completed.',
              )
            : (
                matchType == 'delivery'
                    ? 'Delivery completed'
                    : 'Ride completed',
                'Your $taskLabel task with $moverDisplay on $routeLabel has been completed.',
              );
      case 'cancelled':
        return isMover
            ? (
                'Task cancelled',
                cancellationReason.isNotEmpty
                    ? 'A $taskLabel task was cancelled. Reason: $cancellationReason.'
                    : 'A $taskLabel task on $routeLabel was cancelled.',
              )
            : (
                '${matchType == 'delivery' ? 'Delivery' : 'Ride'} cancelled',
                cancellationReason.isNotEmpty
                    ? 'Your $taskLabel request was cancelled. Reason: $cancellationReason.'
                    : 'Your $taskLabel request on $routeLabel was cancelled.',
              );
      default:
        return null;
    }
  }

  String _buildRouteLabel({
    required String matchType,
    required Map<String, dynamic> request,
  }) {
    if (matchType == 'ride') {
      final origin = request['origin_name']?.toString() ?? 'pickup';
      final destination =
          request['destination_name']?.toString() ?? 'destination';
      return '$origin to $destination';
    }
    final pickup = request['pickup_name']?.toString() ?? 'pickup';
    final dropoff = request['dropoff_name']?.toString() ?? 'destination';
    return '$pickup to $dropoff';
  }

  String _buildStatusLabel(String? rawStatus, String matchType) {
    switch (rawStatus) {
      case 'accepted':
        return matchType == 'delivery' ? 'Accepted' : 'Accepted';
      case 'active':
        return 'In progress';
      case 'completed':
        return 'Completed';
      default:
        return 'Scheduled';
    }
  }

  String _buildRatingLabel({
    required String status,
    required String matchType,
    required bool isMover,
  }) {
    switch (status) {
      case 'accepted':
        if (matchType == 'delivery') {
          return isMover
              ? 'Proceed to pickup item'
              : 'Mover is heading to the pickup location';
        }
        return isMover
            ? 'Waiting for passenger'
            : 'Mover selected for your trip';
      case 'active':
        if (matchType == 'delivery') {
          return isMover
              ? 'Delivery is in progress'
              : 'Your delivery will be delivered in 10 mins';
        }
        return isMover ? 'Trip in progress' : 'Trip is in progress';
      case 'completed':
        return matchType == 'delivery'
            ? 'Delivery completed'
            : 'Trip completed';
      default:
        return 'Waiting for update';
    }
  }

  String _resolveCancellationReason(
    Map<String, dynamic> match,
    Map<String, dynamic> request,
  ) {
    final fromMatch = match['cancelled_reason']?.toString().trim() ?? '';
    if (fromMatch.isNotEmpty) {
      return fromMatch;
    }
    return request['cancelled_reason']?.toString().trim() ?? '';
  }

  String _resolveFullName(
    Map<String, dynamic> user, {
    required String fallback,
  }) {
    final fullName = user['full_name']?.toString().trim() ?? '';
    if (fullName.isNotEmpty) {
      return fullName;
    }
    final firstName = user['first_name']?.toString() ?? '';
    final lastName = user['last_name']?.toString() ?? '';
    final combined = '$firstName $lastName'.trim();
    if (combined.isNotEmpty) {
      return combined;
    }
    final email = user['email']?.toString().trim() ?? '';
    if (email.isNotEmpty) {
      return email;
    }
    return fallback;
  }

  String _formatDateLabel(String? rawDate) {
    final parsed = DateTime.tryParse(rawDate ?? '');
    if (parsed == null) {
      return 'TBD';
    }
    return '${parsed.toLocal().day.toString().padLeft(2, '0')} ${_monthShort(parsed.toLocal().month)}';
  }

  String _formatTimeLabel(String? rawDate) {
    final parsed = DateTime.tryParse(rawDate ?? '');
    if (parsed == null) {
      return '--:--';
    }
    final local = parsed.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  double _safeDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  DateTime _resolveEventDate({
    required Map<String, dynamic> match,
    required Map<String, dynamic> request,
    required String status,
  }) {
    final candidates = <String?>[
      if (status == 'cancelled') match['cancelled_at']?.toString(),
      if (status == 'cancelled') request['cancelled_at']?.toString(),
      request['updated_at']?.toString(),
      match['created_at']?.toString(),
      request['created_at']?.toString(),
    ];

    for (final candidate in candidates) {
      final parsed = DateTime.tryParse(candidate ?? '');
      if (parsed != null) {
        return parsed.toLocal();
      }
    }
    return DateTime.now();
  }

  DateTime _parseDate(String? value) {
    return DateTime.tryParse(value ?? '')?.toLocal() ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _formatTime(DateTime value) {
    final weekday = _weekdayShort(value.weekday);
    final month = _monthShort(value.month);
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.hour >= 12 ? 'PM' : 'AM';
    return '$weekday, ${value.day} $month, $hour:$minute $period';
  }

  String _weekdayShort(int weekday) {
    const values = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return values[weekday - 1];
  }

  String _monthShort(int month) {
    const values = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return values[month - 1];
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _taskSyncSubscription?.cancel();
    super.dispose();
  }
}
