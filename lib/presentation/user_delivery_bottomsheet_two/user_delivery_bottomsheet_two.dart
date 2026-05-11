import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/custom_icon_button.dart';
import '../../core/app_export.dart';
import '../../core/utils/app_toast.dart';
import '../../core/utils/delivery_confirmation_code.dart';
import '../../core/utils/task_interaction_helper.dart';
import '../../widgets/task_route_map.dart';
import 'user_delivery_two_pin_tab.dart';
import 'user_delivery_two_qr_tab.dart';

class UserDeliveryBottomsheetTwo extends ConsumerStatefulWidget {
  const UserDeliveryBottomsheetTwo({Key? key}) : super(key: key);

  @override
  UserDeliveryBottomsheetTwoState createState() =>
      UserDeliveryBottomsheetTwoState();
}

class UserDeliveryBottomsheetTwoState
    extends ConsumerState<UserDeliveryBottomsheetTwo>
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
    final moverName = args['moverName']?.toString() ?? 'Assigned mover';
    final rating = args['rating']?.toString() ??
        'Your delivery will be delivered in 10 mins';
    final pickupLocation =
        args['pickupLocation']?.toString() ?? 'Pickup location';
    final destinationLocation =
        args['destinationLocation']?.toString() ?? 'Destination';
    final requestData = Map<String, dynamic>.from(
      args['requestData'] as Map? ?? const <String, dynamic>{},
    );
    final qrPayload = DeliveryConfirmationCode.buildDeliveryPayload(requestId);
    final pinCode = DeliveryConfirmationCode.buildDeliveryPin(requestId);
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
    final shareLink =
        'https://www.sample.com/?order=${requestId.substring(0, requestId.length > 8 ? 8 : requestId.length)}';

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
                  CustomIconButton(
                    height: 40.h,
                    width: 40.h,
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(10.h),
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2.h,
                      ),
                    ),
                    onTap: NavigatorService.goBack,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgLeftArrow1,
                    ),
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
                      SizedBox(height: 16.h),
                      Text(
                        'Delivery is in progress',
                        style: CustomTextStyles.titleMediumGray80001,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        rating,
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.bodySmall110,
                      ),
                      SizedBox(height: 15.h),
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
                                _buildRouteTimeline(
                                  pickupLocation: pickupLocation,
                                  destinationLocation: destinationLocation,
                                ),
                                SizedBox(height: 38.h),
                                _buildProfileRow(
                                  moverName: moverName,
                                  requestData: requestData,
                                  args: args,
                                ),
                                SizedBox(height: 34.h),
                                Text(
                                  'Kindly send your delivery tag to the receiver. This will confirm that the delivery was successful.',
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyles
                                      .bodyMediumMulishGray800
                                      .copyWith(height: 1.2),
                                ),
                                SizedBox(height: 36.h),
                                _buildTabs(),
                                SizedBox(height: 14.h),
                                _buildTabbar(
                                  qrPayload: qrPayload,
                                  pinCode: pinCode,
                                ),
                                SizedBox(height: 18.h),
                                _buildShareBar(
                                  context,
                                  shareLink: shareLink,
                                ),
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

  Widget _buildRouteTimeline({
    required String pickupLocation,
    required String destinationLocation,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: SizedBox(
            width: 18.h,
            height: 90.h,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 8.h,
                  bottom: 10.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (_) => Container(
                        width: 4.h,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: appTheme.gray300,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: 18.h,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2.h,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 8.h,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 18.h,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pickup Location',
                style: CustomTextStyles.labelLargeBold,
              ),
              SizedBox(height: 6.h),
              Text(
                pickupLocation,
                style: CustomTextStyles.bodySmallGray800,
              ),
              SizedBox(height: 26.h),
              Text(
                'Destination',
                style: CustomTextStyles.labelLargeBold,
              ),
              SizedBox(height: 6.h),
              Text(
                destinationLocation,
                style: CustomTextStyles.bodySmallGray800,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileRow({
    required String moverName,
    required Map<String, dynamic> requestData,
    required Map<String, dynamic> args,
  }) {
    return Row(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgProfile,
          height: 40.h,
          width: 40.h,
          radius: BorderRadius.circular(20.h),
        ),
        SizedBox(width: 10.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                moverName,
                style: CustomTextStyles.bodyMediumMulishBlack900,
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
            ],
          ),
        ),
        _buildActionColumn(
          ImageConstant.imgChatSquare,
          'Chat',
          onTap: () => TaskInteractionHelper.openTaskChat(
            requestData,
            isMoverSide: false,
            args: args,
          ),
        ),
        SizedBox(width: 20.h),
        _buildActionColumn(
          ImageConstant.imgPhoneCall,
          'Call',
          onTap: () => TaskInteractionHelper.callParticipant(
            requestData,
            isMoverSide: false,
          ),
        ),
        SizedBox(width: 20.h),
        _buildActionColumn(
          ImageConstant.imgAlert,
          'Report',
          onTap: () => TaskInteractionHelper.openTaskReport(
            requestData,
            isMoverSide: false,
            requestType: 'delivery',
            args: args,
          ),
        ),
      ],
    );
  }

  Widget _buildActionColumn(String iconPath, String label,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: iconPath,
            height: 18.h,
            width: 18.h,
          ),
          SizedBox(height: 4.h),
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

  Widget _buildTabbar({
    required String qrPayload,
    required String pinCode,
  }) {
    return SizedBox(
      height: 270.h,
      child: TabBarView(
        controller: tabviewController,
        children: [
          UserDeliveryTwoQrTab(qrData: qrPayload),
          UserDeliveryTwoPinTab(pinCode: pinCode),
        ],
      ),
    );
  }

  Widget _buildShareBar(
    BuildContext context, {
    required String shareLink,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(10.h),
        border: Border.all(
          color: appTheme.gray20001,
          width: 1.h,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              shareLink,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodySmallInterGray600,
            ),
          ),
          SizedBox(width: 12.h),
          GestureDetector(
            onTap: () => _copyLink(context, shareLink, 'Link copied'),
            child: Row(
              children: [
                Icon(
                  Icons.copy_outlined,
                  color: theme.colorScheme.primary,
                  size: 16.h,
                ),
                SizedBox(width: 4.h),
                Text(
                  'Copy',
                  style: CustomTextStyles.bodySmallPrimary,
                ),
              ],
            ),
          ),
          SizedBox(width: 16.h),
          GestureDetector(
            onTap: () => _copyLink(context, shareLink, 'Share link copied'),
            child: Row(
              children: [
                Icon(
                  Icons.share_outlined,
                  color: theme.colorScheme.primary,
                  size: 16.h,
                ),
                SizedBox(width: 4.h),
                Text(
                  'Share',
                  style: CustomTextStyles.bodySmallPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyLink(
    BuildContext context,
    String value,
    String message,
  ) async {
    await Clipboard.setData(ClipboardData(text: value));
    AppToast.success(message);
  }

  double _safeDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
