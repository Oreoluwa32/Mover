import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/refer_friends_notifier.dart';

class ReferFriendsScreen extends ConsumerStatefulWidget{
  const ReferFriendsScreen({Key? key}) : super(key: key);

  @override
  ReferFriendsScreenState createState() => ReferFriendsScreenState();
}

class ReferFriendsScreenState extends ConsumerState<ReferFriendsScreen>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(left: 16.h, right: 10.h, top: 16.h),
              child: Column(
                children: [
                  SizedBox(height: 12.h,),
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        _buildEarnedCoins(context),
                        SizedBox(height: 22.h,),
                        Text(
                          "Spread Love",
                          style: CustomTextStyles.labelLargeOnPrimaryContainer,
                        ),
                        SizedBox(height: 8.h,),
                        CustomImageView(
                          imagePath: ImageConstant.imgGift,
                          height: 88.h,
                          width: 88.h,
                        ),
                        SizedBox(height: 12.h,),
                        CustomImageView(
                          imagePath: ImageConstant.imgBitmojiFrame,
                          height: 40.h,
                          width: 142.h,
                        ),
                        SizedBox(height: 24.h,),
                        _buildShare(context),
                        SizedBox(height: 10.h,),
                        _buildOr(context),
                        SizedBox(height: 6.h,),
                        Text(
                          "Share Invitation Code",
                          style: CustomTextStyles.labelLargeOnPrimaryContainer,
                        ),
                        SizedBox(height: 12.h,),
                        Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 44.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCode(context),
                              SizedBox(width: 8.h,),
                              _buildCopy(context)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h,),
                  _buildInstructions(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgCancel,
        margin: EdgeInsets.only(left: 16.h, top: 44.h, bottom: 22.h),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Refer Friends",
        margin: EdgeInsets.only(
          top: 45.h,
          bottom: 20.h
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildHistory(BuildContext context) {
    return CustomElevatedButton(
      height: 30.h,
      width: 104.h,
      text: "View history",
      buttonStyle: CustomButtonStyles.fillPrimaryTL4,
      buttonTextStyle: CustomTextStyles.labelLargeGray50,
    );
  }

  // Section Widget
  Widget _buildEarnedCoins(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.h
      ),
      decoration: BoxDecoration(
        color: appTheme.gray50,
        borderRadius: BorderRadiusStyle.roundedBorder8
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgCoin,
                          height: 18.h,
                          width: 18.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4.h),
                          child: Text(
                            "Total Earned: ",
                            style: CustomTextStyles.titleSmallGray800,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h,),
                  Text(
                    "₦0.00",
                    style: CustomTextStyles.titleMediumGray800,
                  )
                ],
              ),
            ),
          ),
          _buildHistory(context)
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildShare(BuildContext context) {
    return CustomElevatedButton(
      text: "Share Invitation Link"
    );
  }

  // Section Widget
  Widget _buildOr(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Divider(
                color: appTheme.gray30001,
                thickness: 0.h,
              ),
            ),
          ),
          SizedBox(width: 10.h,),
          Align(
            alignment: Alignment.center,
            child: Text(
              "or",
              style: CustomTextStyles.labelLargeOnPrimaryContainer,
            ),
          ),
          SizedBox(width: 10.h,),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Divider(
                color: appTheme.gray30001,
                thickness: 0.h,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildCode(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(referFriendsNotifier).codeController,
          hintText: "Enter invitation code",
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          textStyle: CustomTextStyles.titleSmallPrimary,
        );
      }
    );
  }

  // Section Widget
  Widget _buildCopy(BuildContext context) {
    return CustomElevatedButton(
      height: 32.h,
      width: 70.h,
      text: "Copy",
      buttonStyle: CustomButtonStyles.fillDeepPurple,
    );
  }

  // Section Widget
  Widget _buildOne(BuildContext context) {
    return CustomElevatedButton(
      height: 20.h,
      width: 18.h,
      text: "1",
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToSecondaryContainerDecoration,
      buttonTextStyle: CustomTextStyles.bodySmallOnPrimary!.copyWith(color: appTheme.gray20001),
    );
  }

  // Section Widget
  Widget _buildTwo(BuildContext context) {
    return CustomElevatedButton(
      height: 20.h,
      width: 18.h,
      text: "2",
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToSecondaryContainerDecoration,
      buttonTextStyle: CustomTextStyles.bodySmallOnPrimary!.copyWith(color: appTheme.gray20001),
    );
  }

  // Section Widget
  Widget _buildThree(BuildContext context) {
    return CustomElevatedButton(
      height: 20.h,
      width: 18.h,
      text: "3",
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToSecondaryContainerDecoration,
      buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
    );
  }

  // Section Widget
  Widget _buildFour(BuildContext context) {
    return CustomElevatedButton(
      height: 20.h,
      width: 18.h,
      text: "4",
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToSecondaryContainerDecoration,
      buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
    );
  }

  // Section Widget
  Widget _buildInstructions(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 14.h
      ),
      decoration: BoxDecoration(
        color: appTheme.gray50,
        borderRadius: BorderRadiusStyle.roundedBorder8
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Refer and Get Reward",
            style: CustomTextStyles.labelLargeOnPrimaryContainer
          ),
          SizedBox(height: 20.h,),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      _buildOne(context),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: Text(
                            "Share your invitation code or link to friends",
                            style: CustomTextStyles.bodySmallOnPrimaryContainer,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 22.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      _buildTwo(context),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: Text(
                            "Friends sign up with your invitation code or link",
                            style: CustomTextStyles.bodySmallOnPrimaryContainer,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 22.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      _buildThree(context),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: Text(
                            "Friends perform a task or trip",
                            style: CustomTextStyles.bodySmallOnPrimaryContainer,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 22.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      _buildFour(context),
                      Padding(
                        padding: EdgeInsets.only(left: 8.h),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Get reward of ₦1000",
                                style: CustomTextStyles.bodySmallOnPrimaryContainer,
                              )
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}