import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../data/services/mobility_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../home_one_screen/notifier/home_notifier.dart';

class SearchMoverBottomsheet extends ConsumerStatefulWidget {
  const SearchMoverBottomsheet({
    super.key,
    this.requestType,
    this.requestData,
  });

  final String? requestType;
  final Map<String, dynamic>? requestData;

  @override
  SearchMoverBottomsheetState createState() => SearchMoverBottomsheetState();
}

class SearchMoverBottomsheetState
    extends ConsumerState<SearchMoverBottomsheet> {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  Timer? _pollingTimer;
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _nearbyMovers = const [];
  DateTime? _lastUpdatedAt;

  @override
  void initState() {
    super.initState();
    final homeState = ref.read(homeNotifier);
    _nearbyMovers = List<Map<String, dynamic>>.from(homeState.nearbyMovers);
    _lastUpdatedAt = homeState.nearbyMoverLastUpdatedAt;
    _isLoading =
        homeState.isSearchingNearbyMovers && homeState.nearbyMovers.isEmpty;
    _refreshNearbyMovers();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _refreshNearbyMovers(),
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestData = widget.requestData ?? const <String, dynamic>{};
    final homeState = ref.watch(homeNotifier);
    final isRide = _resolveSearchType(requestData) == 'ride';
    final pickupLocation = _readLocation(
      requestData,
      primaryKey: isRide ? 'origin_name' : 'pickup_name',
      alternateKeys: const ['origin_name', 'pickup_name'],
      fallback: 'Pickup location',
    );
    final destinationLocation = _readLocation(
      requestData,
      primaryKey: isRide ? 'destination_name' : 'dropoff_name',
      alternateKeys: const ['destination_name', 'dropoff_name'],
      fallback: 'Destination',
    );
    final movers = homeState.nearbyMovers.isNotEmpty
        ? homeState.nearbyMovers
        : _nearbyMovers;
    final seenMovers = movers.length;
    final bool hasMovers = seenMovers > 0;

    return Material(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(left: 16.h, top: 16.h, right: 16.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withValues(alpha: 1),
          borderRadius: BorderRadiusStyle.customBorderTL24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 50.h, child: const Divider()),
            SizedBox(height: 14.h),
            Text(
              "Searching for mover",
              style: CustomTextStyles.titleMediumBlack900,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.maxFinite,
              child: Divider(
                color: appTheme.gray20001,
                thickness: 1.h,
              ),
            ),
            SizedBox(height: 18.h),
            _buildSeenMovers(context, seenMovers),
            SizedBox(height: 18.h),
            SizedBox(
              width: double.maxFinite,
              child: Divider(
                color: appTheme.gray20001,
                thickness: 1.h,
              ),
            ),
            SizedBox(height: 18.h),
            _buildLocationCard(
              context,
              pickupLocation: pickupLocation,
              destinationLocation: destinationLocation,
            ),
            SizedBox(height: 26.h),
            CustomElevatedButton(
              text: "View prices",
              isDisabled: !hasMovers,
              buttonStyle: hasMovers
                  ? CustomButtonStyles.fillPrimaryTL41
                  : _disabledViewPricesStyle,
              buttonTextStyle: TextStyle(
                color: hasMovers ? Colors.white : appTheme.gray600,
                fontWeight: FontWeight.w600,
                fontSize: 14.fSize,
              ),
              onPressed: hasMovers
                  ? () {
                      NavigatorService.pushNamed(
                        AppRoutes.hireMoverScreen,
                        arguments: {
                          'requestType': widget.requestType,
                          'requestData': requestData,
                          'nearbyMovers': movers,
                        },
                      );
                    }
                  : null,
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () async {
                final routeId = requestData['id']?.toString() ?? '';

                try {
                  if (routeId.isNotEmpty) {
                    await _mobilityApiService.deleteTravelPlan(
                      travelPlanId: routeId,
                    );
                  }
                } catch (error) {
                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _mobilityApiService.extractErrorMessage(error),
                      ),
                    ),
                  );
                  return;
                }

                ref
                    .read(homeNotifier.notifier)
                    .stopNearbyMoverSearch(clearSearch: true);
                ref.read(homeNotifier.notifier).clearRouteHighlight();
                await ref.read(homeNotifier.notifier).loadPendingTask();
                if (!context.mounted) {
                  return;
                }
                NavigatorService.goBack();
              },
              child: Text(
                "Cancel Request",
                style: CustomTextStyles.titleSmallRedA700Medium,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  ButtonStyle get _disabledViewPricesStyle => ElevatedButton.styleFrom(
        backgroundColor: appTheme.gray10004,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  Widget _buildSeenMovers(BuildContext context, int seenMovers) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 6.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(6.h),
            ),
            child: Text(
              "$seenMovers",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.fSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Text(
              "Movers are going your direction",
              style: CustomTextStyles.titleSmallBlack900,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(
    BuildContext context, {
    required String pickupLocation,
    required String destinationLocation,
  }) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(color: appTheme.gray20001, width: 1.h),
      ),
      child: Column(
        children: [
          _buildLocationRow(context, value: pickupLocation),
          SizedBox(height: 12.h),
          _buildLocationRow(context, value: destinationLocation),
        ],
      ),
    );
  }

  Widget _buildLocationRow(
    BuildContext context, {
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h),
          height: 8.h,
          width: 8.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  String _readLocation(
    Map<String, dynamic> requestData, {
    required String primaryKey,
    List<String> alternateKeys = const [],
    required String fallback,
  }) {
    final value = requestData[primaryKey]?.toString();
    if (value != null && value.isNotEmpty) {
      return value;
    }
    for (final key in alternateKeys) {
      final alternateValue = requestData[key]?.toString();
      if (alternateValue != null && alternateValue.isNotEmpty) {
        return alternateValue;
      }
    }
    return fallback;
  }

  String _resolveSearchType(Map<String, dynamic> requestData) {
    final provided = widget.requestType?.toLowerCase();
    if (provided == 'ride' || provided == 'delivery') {
      return provided!;
    }

    final planType = requestData['plan_type']?.toString().toLowerCase();
    if (planType == 'ride' || planType == 'delivery') {
      return planType!;
    }

    return 'delivery';
  }

  Future<void> _refreshNearbyMovers() async {
    final homeState = ref.read(homeNotifier);
    if (!homeState.isSearchingNearbyMovers) {
      _pollingTimer?.cancel();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _nearbyMovers =
              List<Map<String, dynamic>>.from(homeState.nearbyMovers);
          _lastUpdatedAt = homeState.nearbyMoverLastUpdatedAt;
        });
      }
      return;
    }

    final searchEndsAt = homeState.nearbyMoverSearchEndsAt;
    if (searchEndsAt != null && DateTime.now().isAfter(searchEndsAt)) {
      ref.read(homeNotifier.notifier).stopNearbyMoverSearch();
      _pollingTimer?.cancel();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _nearbyMovers = List<Map<String, dynamic>>.from(
            ref.read(homeNotifier).nearbyMovers,
          );
          _lastUpdatedAt = ref.read(homeNotifier).nearbyMoverLastUpdatedAt;
        });
      }
      return;
    }

    final requestData = widget.requestData ?? const <String, dynamic>{};
    final searchType = _resolveSearchType(requestData);
    final origin = _readLocation(
      requestData,
      primaryKey: searchType == 'ride' ? 'origin_name' : 'pickup_name',
      alternateKeys: const ['origin_name', 'pickup_name'],
      fallback: '',
    );
    final destination = _readLocation(
      requestData,
      primaryKey: searchType == 'ride' ? 'destination_name' : 'dropoff_name',
      alternateKeys: const ['destination_name', 'dropoff_name'],
      fallback: '',
    );

    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }

      final nearbyMovers = await _mobilityApiService.searchAvailableTravelPlans(
        origin: origin,
        destination: destination,
        planType: searchType,
      );
      final liveMovers =
          nearbyMovers.where((plan) => plan['is_live'] == true).toList();
      final updatedAt = DateTime.now();
      ref.read(homeNotifier.notifier).updateNearbyMoverResults(
            movers: liveMovers,
            updatedAt: updatedAt,
          );

      if (!mounted) {
        return;
      }
      setState(() {
        _nearbyMovers = liveMovers;
        _lastUpdatedAt = updatedAt;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = _mobilityApiService.extractErrorMessage(error);
        _isLoading = false;
      });
    }
  }
}
