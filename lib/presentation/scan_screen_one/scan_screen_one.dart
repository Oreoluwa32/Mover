import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_pin_text_field.dart';
import 'notifier/scan_notifier.dart';

class ScanScreenOne extends ConsumerStatefulWidget{
  const ScanScreenOne({Key? key})
    : super(key: key,);

  @override
  ScanScreenOneState createState() => ScanScreenOneState();
}

class ScanScreenOneState extends ConsumerState<ScanScreenOne>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 16.h,
            top: 46.h,
            right: 16.h,
          ),
          child: Column(
            children: [
              Text(
                "Enter pin code",
                style: CustomTextStyles.titleMediumBlack900,
              ),
              SizedBox(height: 52.h),
              SizedBox(
                width: double.maxFinite,
                child: Consumer(
                  builder: (context, ref, _) {
                    return CustomPinTextField(
                      context: context, 
                      controller: ref.watch(scanNotifier).codeController,
                      onChanged: (value) {
                        ref.watch(scanNotifier).codeController?.text = value;
                      },
                    );
                  }
                )
              ),
              SizedBox(height: 52.h),
              GestureDetector(
                onTap: () {
                  NavigatorService.goBack();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Switch to scan",
                      style: CustomTextStyles.titleSmallPurple900,
                    ),
                    SizedBox(width: 12.h),
                    CustomImageView(
                      imagePath: ImageConstant.imgRepeat,
                      height: 18.h,
                      width: 18.h,
                    )
                  ],
                ),
              ),
              SizedBox(height: 4.h)
            ],
          ),
        ),
      );
  }

  // Section Widget 
  PreferredSizeWidget _buildAppbar(BuildContext context){
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
          NavigatorService.pushNamed(AppRoutes.deliveryRatingScreenOne);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Pin Code",
        margin: EdgeInsets.only(
          top: 44.h,
          bottom: 23.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }
}