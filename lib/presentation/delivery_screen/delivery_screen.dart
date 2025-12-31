import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_rating_bar.dart';
import 'models/delivery_item_model.dart';
import 'notifier/delivery_notifier.dart';
import 'widgets/delivery_item_widget.dart';

class DeliveryScreen extends ConsumerStatefulWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  DeliveryScreenState createState() => DeliveryScreenState();
}

class DeliveryScreenState extends ConsumerState<DeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildProfile(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4.h),
                          child: Text(
                            "Reviews (17)",
                            style: CustomTextStyles.titleSmallMedium?.copyWith(color: Colors.black87),
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        _buildRating(context),
                        SizedBox(
                          height: 24.h,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              _buildReview(context),
                              SizedBox(
                                height: 14.h,
                              ),
                              Text(
                                "Prompt delivery and top-notch quality. Impressed with the speed and accuracy. The efficiency and speed at which he delivered the package was impressive.",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyles.bodySmallInterBlack900
                                    .copyWith(height: 1.50),
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              _buildName(context),
                              SizedBox(
                                height: 14.h,
                              ),
                              Text(
                                "Prompt delivery and top-notch quality. Impressed with the speed and accuracy. The efficiency and speed at which he delivered the package was impressive.",
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyles.bodySmallInterBlack900,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: _buildButtonnav(context),
      );
  }

  // Section Widget
  Widget _buildProfile(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        top: 24.h,
        bottom: 22.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          bottom: BorderSide(color: appTheme.gray20001, width: 1.h),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.h,
          ),
          CustomAppBar(
            leadingWidth: 40.h,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imgLeftArrow,
              margin: EdgeInsets.only(left: 16.h),
              onTap: () {
                onTapBack(context);
              },
            ),
            centerTitle: true,
            title: AppbarTitle(
              text: "Mover",
            ),
          ),
          SizedBox(
            height: 60.h,
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgProfile,
                        height: 76.h,
                        width: 76.h,
                        radius: BorderRadius.circular(38.h),
                        alignment: Alignment.topCenter,
                      ),
                      SizedBox(
                        width: 12.h,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jane Doe",
                              style: theme.textTheme.titleSmall?.copyWith(color: Colors.black87),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Text(
                                    "2km away",
                                    style:
                                        CustomTextStyles.bodySmallInterGray600,
                                  ),
                                  Container(
                                    height: 2.h,
                                    width: 2.h,
                                    margin: EdgeInsets.only(left: 4.h),
                                    decoration: BoxDecoration(
                                      color: appTheme.gray700,
                                      borderRadius: BorderRadius.circular(1.h),
                                    ),
                                  ),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgBlackBike,
                                    height: 16.h,
                                    width: 16.h,
                                    margin: EdgeInsets.only(left: 4.h),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "Completed jobs: 26",
                              style: CustomTextStyles.labelMediumGray80001,
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            CustomRatingBar(
                              initialRating: 5,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 12.h,
                      ),
                      Text(
                        "₦3400",
                        style: CustomTextStyles.titleSmallBold?.copyWith(color: Colors.black87),
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

  // Section Widget
  Widget _buildRating(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "5.0",
                style: theme.textTheme.headlineLarge,
              ),
              SizedBox(
                height: 4.h,
              ),
              CustomRatingBar(
                initialRating: 5,
              )
            ],
          ),
          SizedBox(width: 50.h,),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "5",
                          style: CustomTextStyles.labelMediumInterGray80001,
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgYellowStar,
                        height: 15.h,
                        width: 15.h,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.h, top: 5.h),
                          child: SizedBox(
                            height: 6.h,
                            width: 162.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.h),
                              child: LinearProgressIndicator(
                                backgroundColor: appTheme.gray30001,
                                color: appTheme.amber300,
                                value: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "4",
                        style: CustomTextStyles.labelMediumInterGray80001,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgYellowStar,
                        height: 15.h,
                        width: 15.h,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.h, top: 5.h),
                          child: SizedBox(
                            height: 6.h,
                            width: 162.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.h),
                              child: LinearProgressIndicator(
                                backgroundColor: appTheme.gray30001,
                                color: appTheme.amber300,
                                value: 90,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        "3",
                        style: CustomTextStyles.labelMediumInterGray80001,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgYellowStar,
                        height: 15.h,
                        width: 15.h,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.h, top: 5.h),
                          child: SizedBox(
                            height: 6.h,
                            width: 162.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.h),
                              child: LinearProgressIndicator(
                                backgroundColor: appTheme.gray30001,
                                color: appTheme.amber300,
                                value: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        "2",
                        style: CustomTextStyles.labelMediumInterGray80001,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgYellowStar,
                        height: 15.h,
                        width: 15.h,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.h, top: 5.h),
                          child: SizedBox(
                            height: 6.h,
                            width: 162.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.h),
                              child: LinearProgressIndicator(
                                backgroundColor: appTheme.gray30001,
                                color: appTheme.amber300,
                                value: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "1",
                        style: CustomTextStyles.labelMediumInterGray80001,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgYellowStar,
                        height: 15.h,
                        width: 15.h,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: SizedBox(
                            height: 6.h,
                            width: 162.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.h),
                              child: LinearProgressIndicator(
                                backgroundColor: appTheme.gray30001,
                                value: 0,
                              ),
                            ),
                          ),
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

  // Section Widget
  Widget _buildReview(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return ListView.separated(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          DeliveryItemModel model = ref
                  .watch(deliveryNotifier)
                  .deliveryModelObj
                  ?.deliveryItemList[index] ??
              DeliveryItemModel();
          return DeliveryItemWidget(model);
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 22.h,
          );
        },
        itemCount: ref
                .watch(deliveryNotifier)
                .deliveryModelObj
                ?.deliveryItemList
                .length ??
            0,
      );
    });
  }

  // Section Widget
  Widget _buildName(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgProfile,
            height: 40.h,
            width: 40.h,
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "John Doe",
                    style: CustomTextStyles.titleSmallInterBlack900,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgYellowStar,
                          height: 12.h,
                          width: 72.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4.h),
                          child: Text(
                            "5.0",
                            style: CustomTextStyles.bodySmallInterBlack900,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Text(
              "1 hour ago",
              textAlign: TextAlign.right,
              style: CustomTextStyles.bodySmallInterBlack900,
            ),
          )
        ],
      ),
    );
  }

  // Section Wigdet
  Widget _buildButtonnav(BuildContext context) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          top: BorderSide(color: appTheme.gray20001, width: 1.h),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomElevatedButton(
            text: "Hire Mover",
            onPressed: () {
              NavigatorService.pushNamed(AppRoutes.searchMoverBottomsheet);
            },
          )],
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}
