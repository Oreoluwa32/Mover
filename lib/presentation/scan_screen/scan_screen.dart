import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../data/services/mobility_api_service.dart';
import '../home_one_screen/notifier/home_notifier.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  ScanScreenState createState() => ScanScreenState();
}

class ScanScreenState extends ConsumerState<ScanScreen> {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final requestId = args['requestId']?.toString() ?? '';
    final confirmationStage = args['confirmationStage']?.toString() ?? 'pickup';
    final title = confirmationStage == 'delivery'
        ? 'Confirm Delivery'
        : 'Confirm Pickup';
    final qrPayload = confirmationStage == 'delivery'
        ? '$requestId-delivered'
        : requestId;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: _buildAppbar(context, title: title),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(
          left: 16.h,
          top: 24.h,
          right: 16.h,
          bottom: 24.h,
        ),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.h),
                border: Border.all(
                  color: appTheme.gray20001,
                  width: 1.h,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 6.h),
                  CustomImageView(
                    imagePath: ImageConstant.imgQRCode,
                    height: 260.h,
                    width: double.maxFinite,
                  ),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 3.h,
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 20.h),
                      decoration: BoxDecoration(
                        color: appTheme.lightGreen500,
                        borderRadius: BorderRadius.circular(4.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            CustomElevatedButton(
              text: _isSubmitting
                  ? 'Confirming...'
                  : (confirmationStage == 'delivery'
                      ? 'Confirm Delivery'
                      : 'Confirm Pickup'),
              onPressed: _isSubmitting
                  ? null
                  : () => _submitConfirmation(
                        context,
                        verificationCode: qrPayload,
                      ),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                NavigatorService.pushNamed(
                  AppRoutes.scanScreenOne,
                  arguments: args,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Switch to pin code',
                    style: CustomTextStyles.titleSmallPurple900,
                  ),
                  SizedBox(width: 12.h),
                  CustomImageView(
                    imagePath: ImageConstant.imgRepeat,
                    height: 18.h,
                    width: 18.h,
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context, {required String title}) {
    return CustomAppBar(
      height: 92.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeft,
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
        text: title,
        margin: EdgeInsets.only(
          top: 44.h,
          bottom: 21.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  Future<void> _submitConfirmation(
    BuildContext context, {
    required String verificationCode,
  }) async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final matchId = args['matchId']?.toString() ?? '';
    final confirmationStage = args['confirmationStage']?.toString() ?? 'pickup';
    if (matchId.isEmpty) {
      Fluttertoast.showToast(msg: 'Task information is missing.');
      return;
    }
    final homeStateNotifier = ref.read(homeNotifier.notifier);

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (confirmationStage == 'delivery') {
        await _mobilityApiService.confirmDeliveryDropoff(
          matchId: matchId,
          verificationCode: verificationCode,
        );
      } else {
        await _mobilityApiService.confirmDeliveryPickup(
          matchId: matchId,
          verificationCode: verificationCode,
        );
      }
      if (!mounted) {
        return;
      }
      Navigator.of(context).popUntil(
        (route) => route.settings.name == AppRoutes.homeOneScreen || route.isFirst,
      );
      Future<void>.delayed(
        const Duration(milliseconds: 250),
        () => homeStateNotifier.loadPendingTask(),
      );
      Fluttertoast.showToast(
        msg: confirmationStage == 'delivery'
            ? 'Delivery confirmed.'
            : 'Pickup confirmed. Continue to destination.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
      Fluttertoast.showToast(
        msg: _mobilityApiService.extractErrorMessage(error),
      );
    }
  }
}
