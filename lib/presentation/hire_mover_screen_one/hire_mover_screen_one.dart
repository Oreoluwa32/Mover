import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../payment_bottomsheet/payment_bottomsheet.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';

class HireMoverScreenOne extends ConsumerStatefulWidget {
  const HireMoverScreenOne({Key? key}) : super(key: key);

  @override
  HireMoverScreenOneState createState() => HireMoverScreenOneState();
}

class HireMoverScreenOneState extends ConsumerState<HireMoverScreenOne> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final offerData =
        Map<String, dynamic>.from(args['offerData'] as Map? ?? const <String, dynamic>{});
    final travelPlan =
        Map<String, dynamic>.from(offerData['travel_plan'] as Map? ?? const <String, dynamic>{});
    final createdBy =
        Map<String, dynamic>.from(travelPlan['created_by'] as Map? ?? const <String, dynamic>{});

    final moverName = createdBy['full_name']?.toString() ?? 'Nearby mover';
    final routeLabel = travelPlan['origin_name']?.toString() ?? 'Route available';
    final ratingLabel = 'No ratings or reviews';
    final vehicleType = travelPlan['vehicle_type']?.toString().replaceAll('_', ' ') ?? 'Car';
    final homeAwayLabel = createdBy['home_away_label']?.toString() == 'away'
        ? 'Away mover'
        : 'Local mover';
    final priceLabel =
        'NGN ${(offerData['agreed_price'] ?? travelPlan['price_per_seat'] ?? 0).toString()}';

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        leadingWidth: 40.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgLeftArrow,
          margin: EdgeInsets.only(left: 16.h, top: 1.h),
          onTap: () {
            NavigatorService.goBack();
          },
        ),
        centerTitle: true,
        title: AppbarTitle(text: "Mover"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 1),
                  borderRadius: BorderRadiusStyle.roundedBorder12,
                  border: Border.all(color: appTheme.gray20001, width: 1.h),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgProfile,
                      height: 72.h,
                      width: 72.h,
                      radius: BorderRadius.circular(36.h),
                    ),
                    SizedBox(width: 14.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            moverName,
                            style: CustomTextStyles.titleSmallMedium
                                .copyWith(color: Colors.black87),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            homeAwayLabel,
                            style: CustomTextStyles.bodySmallInterGray600,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            _titleCase(vehicleType),
                            style: CustomTextStyles.bodySmallInterGray600,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            ratingLabel,
                            style: CustomTextStyles.labelLargeBluegray400,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      priceLabel,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: Colors.black87),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              _buildInfoCard(
                title: 'Route',
                value: routeLabel,
              ),
              SizedBox(height: 16.h),
              _buildInfoCard(
                title: 'Destination',
                value: travelPlan['destination_name']?.toString() ?? 'Pending destination',
              ),
              SizedBox(height: 16.h),
              _buildInfoCard(
                title: 'Departure',
                value: _formatDeparture(travelPlan['departure_time']?.toString()),
              ),
              SizedBox(height: 16.h),
              _buildInfoCard(
                title: 'Offer',
                value: offerData['agreed_price'] != null
                    ? 'Bid submitted for your request'
                    : 'Standard route price',
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildButtonnav(context),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
  }) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(
          color: appTheme.gray20001,
          width: 1.h,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomTextStyles.labelLargeBold,
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonnav(BuildContext context) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      padding: EdgeInsets.only(left: 16.h, top: 24.h, right: 16.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 1),
        border: Border(
          top: BorderSide(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        children: [
          CustomElevatedButton(
            text: "Hire Mover",
            buttonStyle: CustomButtonStyles.fillPrimaryTL41,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.h),
                  ),
                ),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return PaymentBottomsheet();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDeparture(String? rawDate) {
    final parsed = DateTime.tryParse(rawDate ?? '');
    if (parsed == null) {
      return 'Departure time pending';
    }

    final local = parsed.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final suffix = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  String _titleCase(String value) {
    return value
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
