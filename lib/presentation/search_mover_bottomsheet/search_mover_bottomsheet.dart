import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../data/services/mobility_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../home_one_screen/notifier/home_notifier.dart';

class SearchMoverBottomsheet extends ConsumerStatefulWidget {
  const SearchMoverBottomsheet({
    Key? key,
    this.requestType,
    this.requestData,
  }) : super(key: key);

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
    final isSearching = homeState.isSearchingNearbyMovers;

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
              seenMovers > 0
                  ? "Nearby movers found"
                  : (isSearching ? "Searching for mover" : "Search complete"),
              style: CustomTextStyles.titleMediumBlack900,
            ),
            SizedBox(height: 18.h),
            SizedBox(
              width: double.maxFinite,
              child: Divider(
                color: appTheme.blueGray10001,
                thickness: 3.h,
              ),
            ),
            SizedBox(height: 24.h),
            _buildSeenMovers(context, seenMovers),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.maxFinite,
              child: Divider(
                color: appTheme.gray20001,
                thickness: 1.h,
              ),
            ),
            SizedBox(height: 22.h),
            _buildLocationCard(
              context,
              pickupLocation: pickupLocation,
              destinationLocation: destinationLocation,
            ),
            SizedBox(height: 18.h),
            _buildNearbyMoverSection(context, movers),
            SizedBox(height: 24.h),
            CustomElevatedButton(
              text: "View Prices",
              buttonStyle: CustomButtonStyles.fillPrimaryTL41,
              onPressed: () {
                NavigatorService.pushNamed(
                  AppRoutes.hireMoverScreen,
                  arguments: {
                    'requestType': widget.requestType,
                    'requestData': requestData,
                    'nearbyMovers': movers,
                  },
                );
              },
            ),
            SizedBox(height: 24.h),
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

  Widget _buildSeenMovers(BuildContext context, int seenMovers) {
    final isSearching = ref.watch(homeNotifier).isSearchingNearbyMovers;
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50.h,
            height: 50.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(alpha: 1),
              borderRadius: BorderRadiusStyle.roundedBorder24,
              border: Border.all(
                color: appTheme.gray400,
                width: 1.h,
              ),
            ),
            child: Text(
              "$seenMovers",
              textAlign: TextAlign.center,
              style: CustomTextStyles.titleMediumGray80001,
            ),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Text(
              seenMovers > 0
                  ? "Nearby movers are available for this route"
                  : (isSearching
                      ? "Movers are being searched around your route"
                      : "Search stopped. View current prices or try again."),
              style: CustomTextStyles.titleSmallBlack900,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNearbyMoverSection(
    BuildContext context,
    List<Map<String, dynamic>> movers,
  ) {
    final isSearching = ref.watch(homeNotifier).isSearchingNearbyMovers;
    if (_isLoading) {
      return Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusStyle.roundedBorder8,
          border: Border.all(color: appTheme.gray20001, width: 1.h),
        ),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 12.h),
            Text(
              "Scanning nearby movers...",
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null && _errorMessage!.isNotEmpty) {
      return Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusStyle.roundedBorder8,
          border: Border.all(color: appTheme.gray20001, width: 1.h),
        ),
        child: Text(
          _errorMessage!,
          style: theme.textTheme.bodySmall,
        ),
      );
    }

    if (movers.isEmpty) {
      return Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusStyle.roundedBorder8,
          border: Border.all(color: appTheme.gray20001, width: 1.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "No nearby movers yet",
              style: CustomTextStyles.labelLargeBold,
            ),
            SizedBox(height: 6.h),
            Text(
              isSearching
                  ? "We'll keep checking published routes around your pickup and destination."
                  : "The nearby mover search has ended for now.",
              style: theme.textTheme.bodySmall,
            ),
            if (_lastUpdatedAt != null) ...[
              SizedBox(height: 8.h),
              Text(
                'Last checked ${_formatClock(_lastUpdatedAt!)}',
                style: CustomTextStyles.bodySmallInterGray600,
              ),
            ],
          ],
        ),
      );
    }

    final moversToShow = movers.take(3).toList();
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(color: appTheme.gray20001, width: 1.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nearby Movers",
            style: CustomTextStyles.labelLargeBold,
          ),
          SizedBox(height: 10.h),
          ...moversToShow.map((mover) => _buildMoverRow(context, mover)),
          if (_lastUpdatedAt != null) ...[
            SizedBox(height: 8.h),
            Text(
              'Updated ${_formatClock(_lastUpdatedAt!)}',
              style: CustomTextStyles.bodySmallInterGray600,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMoverRow(BuildContext context, Map<String, dynamic> mover) {
    final createdBy = mover['created_by'] as Map<String, dynamic>? ?? const {};
    final name = createdBy['full_name']?.toString() ?? 'Nearby mover';
    final vehicleType =
        mover['vehicle_type']?.toString().replaceAll('_', ' ') ?? 'vehicle';
    final departure = mover['departure_time']?.toString();

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.h,
            height: 34.h,
            decoration: BoxDecoration(
              color: appTheme.deepPurple50,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'M',
                style: CustomTextStyles.labelLargePrimary,
              ),
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: CustomTextStyles.labelLargeBold,
                ),
                SizedBox(height: 4.h),
                Text(
                  '${_titleCase(vehicleType)} - ${_formatDeparture(departure)}',
                  style: CustomTextStyles.bodySmallInterGray600,
                ),
              ],
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
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(color: appTheme.gray20001, width: 1.h),
      ),
      child: Column(
        children: [
          _buildLocationRow(
            context,
            title: "Pickup",
            value: pickupLocation,
          ),
          SizedBox(height: 12.h),
          _buildLocationRow(
            context,
            title: "Destination",
            value: destinationLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 4.h),
          height: 8.h,
          width: 8.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CustomTextStyles.labelLargeBold,
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: theme.textTheme.bodySmall,
              ),
            ],
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

  String _formatClock(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final suffix = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  String _formatDeparture(String? rawDate) {
    final parsed = DateTime.tryParse(rawDate ?? '');
    if (parsed == null) {
      return 'Departure time pending';
    }
    return _formatClock(parsed.toLocal());
  }

  String _titleCase(String value) {
    return value
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
