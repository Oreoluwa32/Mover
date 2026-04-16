import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class DeliveryPickupScreenTwo extends ConsumerStatefulWidget {
  const DeliveryPickupScreenTwo({Key? key}) : super(key: key);

  @override
  DeliveryPickupScreenTwoState createState() => DeliveryPickupScreenTwoState();
}

class DeliveryPickupScreenTwoState
    extends ConsumerState<DeliveryPickupScreenTwo> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestData = Map<String, dynamic>.from(
      args['requestData'] as Map? ?? const <String, dynamic>{},
    );
    final parsedDetails = _parsePackageDetails(
      requestData['package_description']?.toString() ?? '',
    );
    final description = parsedDetails.description.isNotEmpty
        ? parsedDetails.description
        : requestData['package_description']?.toString() ??
        'No package description was provided.';
    final receiverName = parsedDetails.receiverName.isNotEmpty
        ? parsedDetails.receiverName
        : requestData['receiver_name']?.toString() ?? 'Not provided';
    final receiverPhone = parsedDetails.receiverPhone.isNotEmpty
        ? parsedDetails.receiverPhone
        : requestData['receiver_phone']?.toString() ?? 'Not provided';

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 16.h,
            top: 12.h,
            right: 16.h,
            bottom: 24.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item Image',
                style: CustomTextStyles.labelLargeBlack900.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              Stack(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgShoes,
                    height: 184.h,
                    width: double.maxFinite,
                    radius: BorderRadius.circular(8.h),
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        width: 28.h,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          size: 18.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              Text(
                'Item Description',
                style: CustomTextStyles.labelLargeBlack900.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                description,
                style: CustomTextStyles.bodySmallGray800.copyWith(
                  height: 1.7,
                  color: const Color(0xFF414141),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Delivery Details',
                style: CustomTextStyles.labelLargeBlack900.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusStyle.roundedBorder8,
                  border: Border.all(
                    color: appTheme.gray20001,
                    width: 1.h,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: _buildInfoRow(
                        title: 'Receiver Name',
                        content: receiverName,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: _buildInfoRow(
                        title: 'Receiver Phone Number',
                        content: receiverPhone,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 92.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgCancel,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 44.h,
          bottom: 24.h,
        ),
        onTap: () {
          NavigatorService.goBack();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: 'Delivery Details',
        margin: EdgeInsets.only(
          top: 46.h,
          bottom: 21.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String content,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.h,
          child: Text(
            '$title:',
            style: CustomTextStyles.bodySmallGray800.copyWith(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF3D3D3D),
            ),
          ),
        ),
        SizedBox(
          width: 180.h,
          child: Text(
            content,
            textAlign: TextAlign.right,
            style: CustomTextStyles.bodySmallGray800.copyWith(
              color: const Color(0xFF3D3D3D),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  _PackageDetails _parsePackageDetails(String rawDescription) {
    final lines = rawDescription
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    String receiverName = '';
    String receiverPhone = '';
    final descriptionLines = <String>[];

    for (final line in lines) {
      final lowerLine = line.toLowerCase();
      if (lowerLine.startsWith('receiver:')) {
        receiverName = line.substring(line.indexOf(':') + 1).trim();
        continue;
      }
      if (lowerLine.startsWith('phone:')) {
        receiverPhone = line.substring(line.indexOf(':') + 1).trim();
        continue;
      }
      descriptionLines.add(line);
    }

    return _PackageDetails(
      description: descriptionLines.join('\n'),
      receiverName: receiverName,
      receiverPhone: receiverPhone,
    );
  }
}

class _PackageDetails {
  const _PackageDetails({
    required this.description,
    required this.receiverName,
    required this.receiverPhone,
  });

  final String description;
  final String receiverName;
  final String receiverPhone;
}
