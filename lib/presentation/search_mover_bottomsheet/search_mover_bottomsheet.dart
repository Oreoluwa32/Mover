import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../data/services/mobility_api_service.dart';
import '../../widgets/custom_elevated_button.dart';
import '../home_one_screen/notifier/home_notifier.dart';

// Design tokens taken directly from Figma node 569:10112 so the sheet
// matches the spec without depending on the broader theme drifting.
class _MoverSheetTokens {
  static const Color primaryPurple = Color(0xFF6A1AD3);
  static const Color haloPurple = Color(0xFFDDD4FF); // Blue/200
  static const Color black950 = Color(0xFF262626);
  static const Color black900 = Color(0xFF3D3D3D);
  static const Color black800 = Color(0xFF414141);
  static const Color black300 = Color(0xFFB0B0B0);
  static const Color black200 = Color(0xFFD1D1D1);
  static const Color black50 = Color(0xFFF6F6F6);
  static const Color trackGray = Color(0xFFD9D9D9);
  static const Color redPrimary = Color(0xFFE41212);
}

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
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFloatingMoversIndicator(context, totalMovers: seenMovers),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
            child: Container(
              width: double.maxFinite,
              color: Colors.white,
              padding: EdgeInsets.only(
                left: 16.h,
                right: 16.h,
                top: 16.h,
                bottom: 28.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle: 50x4 grey rounded bar.
                  Center(
                    child: Container(
                      width: 50.h,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: _MoverSheetTokens.black200,
                        borderRadius: BorderRadius.circular(10.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Title.
                  Center(
                    child: Text(
                      "Searching for mover",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.fSize,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 27.h),

                  // Search progress track (grey).
                  Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: _MoverSheetTokens.trackGray,
                      borderRadius: BorderRadius.circular(10.h),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Count circle + "Movers have seen your request".
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50.h,
                        height: 50.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _MoverSheetTokens.black300,
                            width: 1.h,
                          ),
                        ),
                        child: Text(
                          "$seenMovers",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.fSize,
                            color: _MoverSheetTokens.black900,
                            height: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(width: 9.h),
                      Expanded(
                        child: Text(
                          "Movers have seen your request",
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.fSize,
                            color: Colors.black,
                            height: 1.2,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Horizontal divider.
                  Container(
                    height: 1.h,
                    color: const Color(0xFFE7E7E7),
                  ),
                  SizedBox(height: 24.h),

                  // Location pills.
                  _buildLocationPill(
                    address: pickupLocation,
                    isSelected: true,
                  ),
                  SizedBox(height: 8.h),
                  _buildLocationPill(
                    address: destinationLocation,
                    isSelected: false,
                  ),
                  SizedBox(height: 24.h),

                  // View prices button.
                  CustomElevatedButton(
                    text: "View prices",
                    isDisabled: !hasMovers,
                    height: 50.h,
                    buttonStyle: ElevatedButton.styleFrom(
                      backgroundColor: hasMovers
                          ? _MoverSheetTokens.primaryPurple
                          : _MoverSheetTokens.black200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    buttonTextStyle: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                      fontSize: 14.fSize,
                      color: Colors.white,
                      height: 1.2,
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
                  SizedBox(height: 24.h),

                  // Cancel Request.
                  Center(
                    child: GestureDetector(
                      onTap: () => _handleCancelRequest(context, requestData),
                      child: Text(
                        "Cancel Request",
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.fSize,
                          color: _MoverSheetTokens.redPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Floating "<count> Movers are going your direction" pill that sits on
  /// the (dimmed) map just above the rounded sheet.
  Widget _buildFloatingMoversIndicator(
    BuildContext context, {
    required int totalMovers,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.h),
        boxShadow: [
          BoxShadow(
            color: const Color(0x07292D32),
            blurRadius: 4,
            spreadRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.h),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: _MoverSheetTokens.primaryPurple,
                padding:
                    EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
                alignment: Alignment.center,
                child: Text(
                  "$totalMovers",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w700,
                    fontSize: 16.fSize,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding:
                    EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
                alignment: Alignment.center,
                child: Text(
                  "Movers are going your direction",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.fSize,
                    color: _MoverSheetTokens.black800,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationPill({
    required String address,
    required bool isSelected,
  }) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      decoration: BoxDecoration(
        color: _MoverSheetTokens.black50,
        borderRadius: BorderRadius.circular(8.h),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRadioDot(isSelected: isSelected),
          SizedBox(width: 12.h),
          Expanded(
            child: Text(
              address,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w400,
                fontSize: 12.fSize,
                color: _MoverSheetTokens.black950,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioDot({required bool isSelected}) {
    if (isSelected) {
      // Pickup style: filled purple inner over a light-purple halo.
      return Container(
        width: 24.h,
        height: 24.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: _MoverSheetTokens.haloPurple,
        ),
        child: Center(
          child: Container(
            width: 12.h,
            height: 12.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _MoverSheetTokens.primaryPurple,
            ),
          ),
        ),
      );
    }
    // Destination style: hollow purple ring.
    return Container(
      width: 24.h,
      height: 24.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _MoverSheetTokens.primaryPurple,
          width: 2.h,
        ),
      ),
    );
  }

  Future<void> _handleCancelRequest(
    BuildContext context,
    Map<String, dynamic> requestData,
  ) async {
    final routeId = requestData['id']?.toString() ?? '';

    try {
      if (routeId.isNotEmpty) {
        await _mobilityApiService.deleteTravelPlan(travelPlanId: routeId);
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

    ref.read(homeNotifier.notifier).stopNearbyMoverSearch(clearSearch: true);
    ref.read(homeNotifier.notifier).clearRouteHighlight();
    await ref.read(homeNotifier.notifier).loadPendingTask();
    if (!context.mounted) {
      return;
    }
    NavigatorService.goBack();
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
