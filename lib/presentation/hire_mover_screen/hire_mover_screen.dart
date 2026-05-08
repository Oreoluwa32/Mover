import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/task_state_sync.dart';
import '../../data/services/mobility_api_service.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/movr_loading_indicator.dart';
import 'models/mover_item_model.dart';
import 'widgets/mover_item_widget.dart';

class HireMoverScreen extends ConsumerStatefulWidget {
  const HireMoverScreen({Key? key}) : super(key: key);

  @override
  HireMoverScreenState createState() => HireMoverScreenState();
}

class HireMoverScreenState extends ConsumerState<HireMoverScreen> {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  StreamSubscription<TaskStateSyncEvent>? _taskSyncSubscription;
  bool _isLoading = true;
  String? _errorMessage;
  List<MoverItemModel> _moverOffers = const [];
  List<Map<String, dynamic>> _offerPayloads = const [];
  bool _loadedOnce = false;

  @override
  void initState() {
    super.initState();
    _taskSyncSubscription = TaskStateSync.stream.listen((_) {
      if (!mounted) {
        return;
      }
      unawaited(_loadOffers(silent: true));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedOnce) {
      return;
    }
    _loadedOnce = true;
    _loadOffers();
  }

  @override
  void dispose() {
    _taskSyncSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            Text(
              _buildHeading(),
              style: CustomTextStyles.bodyMediumMulishBlack900,
            ),
            SizedBox(height: 20.h),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 60.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgLeftArrow,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          NavigatorService.goBack();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(text: "Movers"),
      actions: [
        AppbarTrailingImage(imagePath: ImageConstant.imgSort),
        AppbarTrailingImage(
          imagePath: ImageConstant.imgFilter,
          margin: EdgeInsets.only(left: 8.h, right: 15.h),
        ),
      ],
      styleType: Style.bgOutline,
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return Expanded(
        child: Center(
          child: MovrLoadingIndicator(
            size: 42.h,
            label: 'Loading mover offers...',
          ),
        ),
      );
    }

    if (_errorMessage != null && _errorMessage!.isNotEmpty) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    if (_moverOffers.isEmpty) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h),
            child: Text(
              "No mover prices are available yet. Check again in a moment.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemCount: _moverOffers.length,
        separatorBuilder: (context, index) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final model = _moverOffers[index];
          final offer = _offerPayloads[index];
          return GestureDetector(
            onTap: () {
              final args = ModalRoute.of(context)?.settings.arguments
                      as Map<String, dynamic>? ??
                  const <String, dynamic>{};
              NavigatorService.pushNamed(
                AppRoutes.hireMoverScreenOne,
                arguments: {
                  'offerData': offer,
                  'requestType': args['requestType'],
                  'requestData': args['requestData'],
                },
              );
            },
            child: MoverItemWidget(model),
          );
        },
      ),
    );
  }

  Future<void> _loadOffers({bool silent = false}) async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestType = args['requestType']?.toString() ?? '';
    final requestData = Map<String, dynamic>.from(
        args['requestData'] as Map? ?? const <String, dynamic>{});
    final requestId = requestData['id']?.toString() ?? '';
    final nearbyMovers = List<Map<String, dynamic>>.from(
        args['nearbyMovers'] as List? ?? const []);

    try {
      if (!silent && mounted) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }
      final matches = await _mobilityApiService.getMatches();
      final matchedOffers = matches.where((match) {
        if (requestType == 'ride') {
          final rideRequest = match['ride_request'];
          return rideRequest is Map &&
              rideRequest['id']?.toString() == requestId;
        }
        if (requestType == 'delivery') {
          final deliveryRequest = match['delivery_request'];
          return deliveryRequest is Map &&
              deliveryRequest['id']?.toString() == requestId;
        }
        return false;
      }).toList()
        ..sort((left, right) =>
            _offerPriority(right).compareTo(_offerPriority(left)));

      final payloads = matchedOffers.isNotEmpty
          ? matchedOffers
          : nearbyMovers.map((plan) => {'travel_plan': plan}).toList();

      if (!mounted) {
        return;
      }
      setState(() {
        _offerPayloads = payloads;
        _moverOffers = payloads.map(_mapOfferToItem).toList();
        _isLoading = false;
        _errorMessage = null;
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

  String _buildHeading() {
    if (_isLoading) {
      return "Checking nearby mover prices";
    }
    if (_moverOffers.isEmpty) {
      return "No mover prices yet";
    }
    if (_offerPayloads
        .any((offer) => offer['status']?.toString() == 'accepted')) {
      return "Mover selected";
    }
    if (_offerPayloads.any((offer) => offer['agreed_price'] != null)) {
      return "${_moverOffers.length} movers have sent prices";
    }
    return "${_moverOffers.length} nearby movers available";
  }

  MoverItemModel _mapOfferToItem(Map<String, dynamic> offer) {
    final travelPlan =
        Map<String, dynamic>.from(offer['travel_plan'] as Map? ?? const {});
    final createdBy =
        Map<String, dynamic>.from(travelPlan['created_by'] as Map? ?? const {});
    final vehicleType = travelPlan['vehicle_type']?.toString() ?? '';
    final fullName = createdBy['full_name']?.toString();
    final homeAwayLabel = createdBy['home_away_label']?.toString() ?? 'home';
    final price = offer['agreed_price'] ?? travelPlan['price_per_seat'] ?? 0;

    return MoverItemModel(
      profileImage: ImageConstant.imgProfile,
      moverName: fullName?.isNotEmpty == true ? fullName! : "Nearby mover",
      homeAway: homeAwayLabel == 'away'
          ? ImageConstant.imgAway
          : ImageConstant.imgHomeIcon,
      distance: _buildDistanceLabel(travelPlan),
      vehicleType: _mapVehicleIcon(vehicleType),
      price: '₦ ${price.toString()}',
      id: travelPlan['id']?.toString() ?? '',
    );
  }

  String _buildDistanceLabel(Map<String, dynamic> travelPlan) {
    final origin = travelPlan['origin_name']?.toString();
    if (origin != null && origin.isNotEmpty) {
      return origin;
    }
    return 'Route available';
  }

  String _mapVehicleIcon(String vehicleType) {
    switch (vehicleType) {
      case 'bike':
        return ImageConstant.imgBlackBike;
      case 'car':
        return ImageConstant.imgBlackCar;
      case 'public_transit':
        return ImageConstant.imgBlackManWalk;
      default:
        return ImageConstant.imgBlackCar;
    }
  }

  int _offerPriority(Map<String, dynamic> offer) {
    switch (offer['status']?.toString()) {
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
}
