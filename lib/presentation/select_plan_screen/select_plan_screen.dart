import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';

class SelectPlanScreen extends StatelessWidget{
  const SelectPlanScreen({Key? key})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 32.h),
          child: Column(
            children: [
              _buildColumnselectapl(context),
              SizedBox(height: 24.h),
              _buildHorizontalscroll(context),
              SizedBox(height: 24.h),
              _buildColumnfeatures(context),
              SizedBox(height: 4.h)
            ],
          ),
        ),
        bottomNavigationBar: _buildColumnduration(context),
      ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context){
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgCancel,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 44.h,
          bottom: 22.h,
        ),
        onTap: () {},
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Select a Plan",
        margin: EdgeInsets.only(
          top: 45.h,
          bottom: 20.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildColumnselectapl(BuildContext context){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 16.h,
        right: 30.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select a plan",
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 12.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'By selecting a plan, you agree to our "',
                  style: CustomTextStyles.bodySmallBlack900,
                ),
                TextSpan(
                  text: "Terms of Service",
                  style: CustomTextStyles.bodySmallPrimary.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: '" and "',
                  style: CustomTextStyles.bodySmallBlack900,
                ),
                TextSpan(
                  text: "Privacy Policy",
                  style: CustomTextStyles.bodySmallPrimary.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: '"',
                  style: CustomTextStyles.bodySmallBlack900,
                )
              ]
            ),
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  // Section Widget 
  Widget _buildHorizontalscroll(BuildContext context){
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: SizedBox(
            width: 1200.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 122.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.h,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                    border: Border.all(
                      color: appTheme.gray400,
                      width: 1.h,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgPurpleCheck,
                        height: 16.h,
                        width: 16.h,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "#0",
                              style: CustomTextStyles.titleMediumGray80001,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "per month",
                                style: CustomTextStyles.titleSmallGray600Medium,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h)
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.h),
                    child: _buildPlanThree(
                      context,
                      iconparksolid: ImageConstant.imgPurpleCheck,
                      basicplanTwo: "Basic",
                      priceThree: "#1,200",
                      periodTwo: "per month",
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 48.h,
                      margin: EdgeInsets.only(left: 8.h),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(

                        borderRadius: BorderRadiusStyle.roundedBorder8,
                        border: Border.all(
                          color: appTheme.gray400,
                          width: 1.h,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: Text(
                              "Rover",
                              style: CustomTextStyles.titleSmallErrorContainer,
                            ),
                          ),
                          SizedBox(width: 14.h),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            decoration: BoxDecoration(
                              color: appTheme.deepPurple50,
                            ),
                            child: Text(
                              "Popular",
                              textAlign: TextAlign.left,
                              style: theme.textTheme.labelSmall,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 270.h),
                      child: _buildPlanThree(
                        context,
                        iconparksolid: ImageConstant.imgPurpleCheck,
                        basicplanTwo: "Courier",
                        priceThree: "#9,400",
                        periodTwo: "per month",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.h),
                      child: _buildPlanThree(
                        context,
                        iconparksolid: ImageConstant.imgPurpleCheck,
                        basicplanTwo: "Courier plus",
                        priceThree: "#15,200",
                        periodTwo: "per month",
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Widget 
  Widget _buildColumnfeatures(BuildContext context){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FEATURES",
            style: CustomTextStyles.titleSmallErrorContainerBold,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: _buildRowcheckmark(
                    context,
                    monetize20: "Includes 10 trip searches per month",
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildRowcheckmark(
                    context,
                    monetize20: "Monetize 20 trips",
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section Widget 
  Widget _buildColumnduration(BuildContext context){
    return Container(
      height: 116.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "1-week free trial. We'll send you a reminder 2 days before your trial ends.",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bodyMediumMulishGray600.copyWith(
              height: 1.43,
            ),
          ),
          SizedBox(height: 14.h),
          CustomElevatedButton(
            text: "Try for free",
            margin: EdgeInsets.only(bottom: 12.h),
            buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
            onPressed: () {onTapTryForFree(context);},
          )
        ],
      ),
    );
  }

  // Common Widget 
  Widget _buildPlanThree(
    BuildContext context, {
      required String iconparksolid, 
      required String basicplanTwo, 
      required String priceThree,
      required String periodTwo,
    }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(
          color: appTheme.gray400,
          width: 1.h,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: iconparksolid,
            height: 16.h,
            width: 16.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  basicplanTwo,
                  style: CustomTextStyles.titleSmallErrorContainer.copyWith(
                    color: theme.colorScheme.errorContainer,
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    priceThree,
                    style: CustomTextStyles.titleMediumGray8000118.copyWith(
                      color: appTheme.gray800,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    periodTwo,
                    style: CustomTextStyles.titleSmallGray600Medium.copyWith(
                      color: appTheme.gray600,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 4.h)
        ],
      ),
    );
  }

  // Common Widget 
  Widget _buildRowcheckmark(
    BuildContext context, {
      required String monetize20,
  }) {
    return Row(
      children: [
        Container(
          height: 18.h,
          width: 18.h,
          decoration: BoxDecoration(
            color: appTheme.deepPurple50,
            borderRadius: BorderRadiusStyle.roundedBorder8,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgPurpleCheckmark,
                height: 6.h,
                width: 8.h,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.h),
          child: Text(
            monetize20,
            style: CustomTextStyles.bodyMediumGray600.copyWith(
              color: appTheme.gray600,
            ),
          ),
        )
      ],
    );
  }

  // Navigates to the home screen dialog
  onTapTryForFree(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.homeScreenDialog);
  }

  // Navigates to the 
}