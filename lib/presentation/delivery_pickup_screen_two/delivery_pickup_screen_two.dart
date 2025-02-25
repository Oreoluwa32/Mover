import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import 'notifier/pickup_notifier.dart';

class DeliveryPickupScreenTwo extends ConsumerStatefulWidget{
  const DeliveryPickupScreenTwo({Key? key})
    : super(key: key,);

  @override
  DeliveryPickupScreenTwoState createState() => DeliveryPickupScreenTwoState();
}

class DeliveryPickupScreenTwoState extends ConsumerState<DeliveryPickupScreenTwo>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 16.h,
            top: 40.h,
            right: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Item Image",
                style: theme.textTheme.labelLarge,
              ),
              SizedBox(height: 10.h),
              _buildStack(context),
              SizedBox(height: 28.h),
              Text(
                "Item Description",
                style: theme.textTheme.labelLarge,
              ),
              SizedBox(height: 12.h,),
              Container(
                width: 332.h,
                margin: EdgeInsets.only(right: 8.h),
                child: Text(
                  "Box of assorted clothes for delivery. This package contains a mix of casual and formal wear, including shirts, pants, dresses, and accessories. All items are clean, neatly folded, and in excellent condition.",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.bodySmallGray800.copyWith(height: 1.50),
                ),
              ),
              SizedBox(height: 26.h),
              _buildColumn(context),
              SizedBox(height: 4.h)
            ],
          ),
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
        text: "Delivery Details",
        margin: EdgeInsets.only(
          top: 46.h,
          bottom: 21.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildStack(BuildContext context){
    return SizedBox(
      height: 164.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgShoes,
            height: 164.h,
            width: double.maxFinite,
            radius: BorderRadius.circular(8.h),
          ),
          // `CustomIconButton(
          //   height: 24.h,
          //   width: 24.h,
          //   padding: EdgeInsets.all(2.h),
          //   child: CustomImageView(
          //     imagePath: ImageConstant,
          //   ),
          // )`
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildColumn(BuildContext context){
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: _buildReceiver(
                    context,
                    title: "Receiver Name:",
                    content: "Samuel Oluwatobi",
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildReceiver(
                    context,
                    title: "Receiver Phone Number",
                    content: "08010000000",
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Common Widget
  Widget _buildReceiver(BuildContext context, {
    required String title,
    required String content,
  }){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: CustomTextStyles.labelLargeBlack900.copyWith(color: appTheme.black900),
        ),
        Text(
          content,
          style: CustomTextStyles.bodySmallBlack900.copyWith(color: appTheme.black900),
        )
      ],
    );
  }
}