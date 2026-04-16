import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../widgets/custom_icon_button.dart';
import '../../core/app_export.dart';
import '../../core/utils/task_interaction_helper.dart';
import '../../widgets/task_route_map.dart';
import 'user_delivery_pin_tab.dart';
import 'user_delivery_qr_tab.dart';

class UserDeliveryBottomsheetOne extends ConsumerStatefulWidget {
  const UserDeliveryBottomsheetOne({super.key});

  @override
  UserDeliveryBottomsheetOneState createState() =>
      UserDeliveryBottomsheetOneState();
}

class UserDeliveryBottomsheetOneState
    extends ConsumerState<UserDeliveryBottomsheetOne>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestId = args['requestId']?.toString() ?? 'movr-request';
    final requestType = args['requestType']?.toString() ?? 'delivery';
    final moverName = args['moverName']?.toString() ?? 'Assigned mover';
    final requestData = Map<String, dynamic>.from(
      args['requestData'] as Map? ?? const <String, dynamic>{},
    );
    final pinCode = _buildPinFromRequestId(requestId);
    final travelPlan = Map<String, dynamic>.from(
      requestData['_travel_plan'] as Map? ?? const <String, dynamic>{},
    );
    final pickupLatitude = _safeDouble(
      requestData['pickup_latitude'] ?? requestData['origin_latitude'],
    );
    final pickupLongitude = _safeDouble(
      requestData['pickup_longitude'] ?? requestData['origin_longitude'],
    );
    final destinationLatitude = _safeDouble(
      requestData['dropoff_latitude'] ?? requestData['destination_latitude'],
    );
    final destinationLongitude = _safeDouble(
      requestData['dropoff_longitude'] ?? requestData['destination_longitude'],
    );
    final moverLatitude = _safeDouble(travelPlan['origin_latitude']);
    final moverLongitude = _safeDouble(travelPlan['origin_longitude']);

    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: Stack(
        children: [
          Positioned.fill(
            child: TaskRouteMap(
              pickupLatitude: pickupLatitude,
              pickupLongitude: pickupLongitude,
              destinationLatitude: destinationLatitude,
              destinationLongitude: destinationLongitude,
              moverLatitude: moverLatitude == 0 ? null : moverLatitude,
              moverLongitude: moverLongitude == 0 ? null : moverLongitude,
              routeColor: const Color(0xFF2F2F2F),
              showMoverRadius: true,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
              child: Row(
                children: [
                  _buildMapButton(
                    icon: ImageConstant.imgLeftArrow,
                    onTap: NavigatorService.goBack,
                  ),
                  const Spacer(),
                  _buildMapButton(
                    icon: ImageConstant.imgPackageBlack,
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.5,
            maxChildSize: 0.75,
            snap: true,
            snapSizes: const [0.5, 0.75],
            builder: (context, scrollController) {
              return Container(
                width: double.maxFinite,
                padding: EdgeInsets.fromLTRB(16.h, 12.h, 16.h, 24.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.h),
                    topRight: Radius.circular(28.h),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20.h,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Container(
                        width: 52.h,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: appTheme.gray300,
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        'Mover will arrive in 10mins',
                        style: CustomTextStyles.titleMediumGray80001,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false,
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildMoverCard(moverName),
                                SizedBox(height: 24.h),
                                _buildActionsRow(
                                  requestData: requestData,
                                  args: args,
                                  requestType: requestType,
                                ),
                                SizedBox(height: 24.h),
                                _buildTabs(),
                                SizedBox(height: 10.h),
                                _buildTabBarView(
                                  requestId: requestId,
                                  pinCode: pinCode,
                                ),
                                SizedBox(height: 18.h),
                                GestureDetector(
                                  onTap: () async {
                                    final matchMap = Map<String, dynamic>.from(
                                      requestData['_match'] as Map? ?? const <String, dynamic>{},
                                    );
                                    final cancelled = await NavigatorService.pushNamed(
                                      AppRoutes.rideCancelScreenOne,
                                      arguments: {
                                        'matchId': requestData['_match_id']?.toString() ??
                                            matchMap['id']?.toString() ??
                                            '',
                                        'requestId': requestData['id']?.toString() ?? requestId,
                                        'requestType': requestType,
                                        'source': 'requester_task',
                                      },
                                    );
                                    if (cancelled == true && mounted) {
                                      NavigatorService.goBack();
                                    }
                                  },
                                  child: Text(
                                    'Cancel Request',
                                    style: CustomTextStyles.titleSmallRedA700,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton({
    required String icon,
    VoidCallback? onTap,
  }) {
    return CustomIconButton(
      height: 40.h,
      width: 40.h,
      padding: EdgeInsets.all(10.h),
      decoration: IconButtonStyleHelper.outlineBlackTL201,
      onTap: onTap,
      child: CustomImageView(
        imagePath: icon,
      ),
    );
  }

  Widget _buildMoverCard(String moverName) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(
          color: appTheme.gray20001,
          width: 1.h,
        ),
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgProfile,
            height: 48.h,
            width: 48.h,
            radius: BorderRadius.circular(24.h),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moverName,
                  style: CustomTextStyles.bodyMediumMulishGray800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      '2km away',
                      style: CustomTextStyles.bodySmallInterGray600,
                    ),
                    Container(
                      width: 2.h,
                      height: 2.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.h),
                      decoration: BoxDecoration(
                        color: appTheme.gray700,
                        shape: BoxShape.circle,
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgBlackCar,
                      height: 14.h,
                      width: 14.h,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'No ratings or reviews',
                  style: CustomTextStyles.labelLargeBluegray400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsRow({
    required Map<String, dynamic> requestData,
    required Map<String, dynamic> args,
    required String requestType,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAction(
          ImageConstant.imgChatSquare,
          'Chat',
          onTap: () => TaskInteractionHelper.openTaskChat(
            requestData,
            isMoverSide: false,
            args: args,
          ),
        ),
        _buildAction(
          ImageConstant.imgPhoneCall,
          'Call',
          onTap: () => TaskInteractionHelper.callParticipant(
            requestData,
            isMoverSide: false,
          ),
        ),
        _buildAction(
          ImageConstant.imgAlert,
          'Report',
          onTap: () => TaskInteractionHelper.openTaskReport(
            requestData,
            isMoverSide: false,
            requestType: requestType,
            args: args,
          ),
        ),
      ],
    );
  }

  Widget _buildAction(String iconPath, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
      children: [
        CustomImageView(
          imagePath: iconPath,
          height: 24.h,
          width: 24.h,
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      width: double.maxFinite,
      child: TabBar(
        controller: tabviewController,
        labelPadding: EdgeInsets.zero,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        tabs: [
          _buildTab(title: 'QR Code', selected: tabIndex == 0),
          _buildTab(title: 'Pin Code', selected: tabIndex == 1),
        ],
        onTap: (index) {
          setState(() {
            tabIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required bool selected,
  }) {
    return Tab(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? theme.colorScheme.primary : appTheme.gray300,
              width: selected ? 2.h : 1.h,
            ),
          ),
        ),
        child: Text(
          title,
          style: selected
              ? CustomTextStyles.bodyMediumMulishGray800
              : CustomTextStyles.bodyMediumMulishGray800?.copyWith(
                  color: appTheme.blueGray400,
                ),
        ),
      ),
    );
  }

  Widget _buildTabBarView({
    required String requestId,
    required String pinCode,
  }) {
    return SizedBox(
      height: 330.h,
      child: TabBarView(
        controller: tabviewController,
        children: [
          UserDeliveryQrTab(
            child: QrImageView(
              data: requestId,
              size: 190.h,
              backgroundColor: Colors.white,
            ),
          ),
          UserDeliveryPinTab(pinCode: pinCode),
        ],
      ),
    );
  }

  String _buildPinFromRequestId(String requestId) {
    final digits = requestId.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 6) {
      return digits.substring(0, 6);
    }

    final seed = requestId.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    return (100000 + (seed % 900000)).toString();
  }

  double _safeDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
