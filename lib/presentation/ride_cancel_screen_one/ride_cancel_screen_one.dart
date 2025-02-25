import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_radio_button.dart';
import 'notifier/ride_cancel_notifier.dart';

class RideCancelScreenOne extends ConsumerStatefulWidget{
  const RideCancelScreenOne({Key? key})
    : super(key: key,);

  @override
  RideCancelScreenOneState createState() => RideCancelScreenOneState();
}

class RideCancelScreenOneState extends ConsumerState<RideCancelScreenOne>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: 16.h,
                  top: 2.h,
                  right: 16.h,
                ),
                child: Column(
                  children: [
                    Text(
                      "What went wrong?",
                      style: CustomTextStyles.titleMediumGray80001,
                    ),
                    SizedBox(height: 30.h),
                    _buildColumnradio(context),
                    SizedBox(height: 4.h)
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildColumndone(context),
      )
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context){
    return CustomAppBar(
      height: 56.h,
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgCancel,
          margin: EdgeInsets.only(
            top: 16.h,
            right: 15.h,
            bottom: 16.h,
          ),
          onTap: () {
            NavigatorService.pushNamed(AppRoutes.homeOneScreen);
          },
        )
      ],
    );
  }

  // Section Widget
  Widget _buildColumnradio(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Consumer(
              builder: (context, ref, _) {
                return Column(
                  children: [
                    CustomRadioButton(
                      width: 342.h,
                      text: "Long pickup time",
                      value: "Long pickup time",
                      groupValue: ref.watch(rideCancelNotifier).radioGroup,
                      textStyle: CustomTextStyles.bodyMediumMulishGray800,
                      isRightCheck: true,
                      onChange: (value){
                        ref.read(rideCancelNotifier.notifier).changeRadioBtn(value);
                      },
                    ),
                    SizedBox(height: 15.h,),
                    Divider(
                      color: appTheme.gray20001,
                      thickness: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: CustomRadioButton(
                        width: 342.h,
                        text: "Mover not at pickup point",
                        value: "Mover not at pickup point",
                        groupValue: ref.watch(rideCancelNotifier).radioGroup,
                        textStyle: CustomTextStyles.bodyMediumMulishGray800,
                        isRightCheck: true,
                        onChange: (value) {
                          ref.read(rideCancelNotifier.notifier).changeRadioBtn(value);
                        },
                      ),
                    ),
                    SizedBox(height: 15.h,),
                    Divider(
                      color: appTheme.gray20001,
                      thickness: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: CustomRadioButton(
                        width: 342.h,
                        text: "Mover asked to pay off the app",
                        value: "Mover asked to pay off the app",
                        groupValue: ref.watch(rideCancelNotifier).radioGroup,
                        textStyle: CustomTextStyles.bodyMediumMulishGray800,
                        isRightCheck: true,
                        onChange: (value) {
                          ref.read(rideCancelNotifier.notifier).changeRadioBtn(value);
                        },
                      ),
                    ),
                    SizedBox(height: 15.h,),
                    Divider(
                      color: appTheme.gray20001,
                      thickness: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: CustomRadioButton(
                        width: 342.h,
                        text: "Mover asked to cancel",
                        value: "Mover asked to cancel",
                        groupValue: ref.watch(rideCancelNotifier).radioGroup,
                        textStyle: CustomTextStyles.bodyMediumMulishGray800,
                        isRightCheck: true,
                        onChange: (value) {
                          ref.read(rideCancelNotifier.notifier).changeRadioBtn(value);
                        },
                      ),
                    ),
                    SizedBox(height: 15.h,),
                    Divider(
                      color: appTheme.gray20001,
                      thickness: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: CustomRadioButton(
                        width: 342.h,
                        text: "Can't find the mover",
                        value: "Can't find the mover",
                        groupValue: ref.watch(rideCancelNotifier).radioGroup,
                        textStyle: CustomTextStyles.bodyMediumMulishGray800,
                        isRightCheck: true,
                        onChange: (value) {
                          ref.read(rideCancelNotifier.notifier).changeRadioBtn(value);
                        },
                      ),
                    )
                  ],
                );
              }
            )
          ),
          SizedBox(height: 15.h,),
          Divider(
            color: appTheme.gray20001,
            thickness: 1.h,
          ),
          SizedBox(height: 15.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Other reason",
                  style: CustomTextStyles.bodyMediumMulishGray800,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgChevronRight,
                  height: 20.h,
                  width: 20.h,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildColumndone(BuildContext context){
    return Container(
      height: 62.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomElevatedButton(
            text: "Done",
            margin: EdgeInsets.only(bottom: 12.h),
            onPressed: () {
              NavigatorService.pushNamed(AppRoutes.homeOneScreen);
            },
          )
        ],
      ),
    );
  }
}