import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../activity_in_progress_page/activity_in_progress_page.dart';
import '../my_route_page/my_route_page.dart';
// import '..';

// ignore for file, must be immutable

class HomeDeliveryRequestScreen extends StatelessWidget{
  HomeDeliveryRequestScreen({Key? key})
    : super(key: key,);

  Completer<GoogleMapController> googleMapController = Completer();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              height: 1148.h,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  _buildHorizontalscrol(context),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 40.h,
                      margin: EdgeInsets.only(
                        left: 16.h,
                        top: 48.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.h,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onPrimary.withOpacity(1),
                        borderRadius: BorderRadiusStyle.CircleBorder20,
                        boxShadow: [
                          BoxShadow(
                            color: appTheme.black900.withOpacity(0.1),
                            spreadRadius: 2.h,
                            blurRadius: 2.h,
                            offset: Offset(0, 0,),
                          )
                        ]
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgWalking,
                            height: 18.h,
                            width: double.maxFinite,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.h),
                            child: Text(
                              "PT",
                              style: CustomTextStyles.interErrorContainer,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          child: _buildBottombar(context),
        ),
        floatingActionButton: _buildFloatingactionb(context),
      )
    );
  }

  // Section Widget
  Widget _buildHorizontalscrol(BuildContext context){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Container(
          height: 1148.h,
          width: 968.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withOpacity(1),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              CustomImageView(
                // imagePath: ImageConstant,
                height: 852.h,
                width: double.maxFinite,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 646.h,
                    width: 1202.h,
                    child: Stack(
                      alignment: 
                      Alignment.centerRight,
                      children: [
                        SizedBox(
                          height: 646.h,
                          width: 928.h,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(37.43296265331129, -122.08832357078792,),
                              zoom: 14.4746,
                            ),
                            onMapCreated: (GoogleMapController controller){
                              googleMapController.complete(controller);
                            },
                            zoomControlsEnabled: false,
                            zoomGesturesEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: false,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 344.h,
                              top: 48.h,
                              right: 514.h,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 146.h,
                                        margin: EdgeInsets.only(left: 44.h),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.h,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: appTheme.gray10001,
                                          borderRadius: BorderRadiusStyle.CircleBorder20,
                                          boxShadow: [
                                            BoxShadow(
                                              color: appTheme.black900.withOpacity(0.08),
                                              spreadRadius: 2.h,
                                              blurRadius: 2.h,
                                              offset: Offset(0, 0,),
                                            )
                                          ]
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 6.h,
                                              width: 6.h,
                                              decoration: BoxDecoration(
                                                color: appTheme.redA700,
                                                borderRadius: BorderRadius.circular(3.h),
                                              ),
                                            ),
                                            SizedBox(width: 6.h),
                                            Text(
                                              "1000+ routes are live",
                                              style: CustomTextStyles.labelMediumInterPrimary,
                                            )
                                          ],
                                        ),
                                      ),
                                      CustomIconButton(
                                        height: 40.h,
                                        width: 40.h,
                                        padding: EdgeInsets.all(10.h),
                                        decoration: IconButtonStyleHelper.outlineBlackTL201,
                                        child: CustomImageView(imagePath: ImageConstant.imgNotificationBell,),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                SizedBox(
                                  height: 90.h,
                                  width: double.maxFinite,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CustomImageView(
                                        imagePath: ImageConstant.imgWalkingLady,
                                        height: 40.h,
                                        width: 28.h,
                                        alignment: Alignment.bottomLeft,
                                        margin: EdgeInsets.only(
                                          left: 102.h,
                                          bottom: 10.h,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: 24.h,
                                          width: 44.h,
                                          margin: EdgeInsets.only(top: 8.h),
                                          padding: EdgeInsets.all(2.h),
                                          decoration: BoxDecoration(
                                            color: appTheme.deepPurple600,
                                            borderRadius: BorderRadiusStyle.CircleBorder20,
                                            boxShadow: [
                                              BoxShadow(
                                                color: appTheme.black900.withOpacity(0.1),
                                                spreadRadius: 2.h,
                                                blurRadius: 2.h,
                                                offset: Offset(0, 0,),
                                              )
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "ON",
                                                style: CustomTextStyles.labelMediumOnPrimary,
                                              ),
                                              SizedBox(width: 4.h),
                                              Container(
                                                height: 18.h,
                                                width: 18.h,
                                                decoration: BoxDecoration(
                                                  color: theme.colorScheme.onPrimary.withOpacity(1),
                                                  borderRadius: BorderRadius.circular(8.h,),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 90.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.h,
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.onPrimary.withOpacity(1),
                                          borderRadius: BorderRadiusStyle.roundedBorder8,
                                          boxShadow: [
                                            BoxShadow(
                                              color: appTheme.gray9000c,
                                              spreadRadius: 2.h,
                                              blurRadius: 2.h,
                                              offset: Offset(0, 4,),
                                            )
                                          ]
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomIconButton(
                                              height: 40.h,
                                              width: 40.h,
                                              padding: EdgeInsets.all(10.h),
                                              decoration: IconButtonStyleHelper.outlineDeepPurple,
                                              child: CustomImageView(
                                                imagePath: ImageConstant.imgPackage,
                                              ),
                                            ),
                                            SizedBox(width: 16.h),
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 6.h),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Delivery task",
                                                        style: CustomTextStyles.titleSmallInter,
                                                      ),
                                                      Text(
                                                        "You have a delivery request",
                                                        style: CustomTextStyles.bodySmallErrorContainer,
                                                      ),
                                                      SizedBox(
                                                        width: double.maxFinite,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "View Details",
                                                              style: CustomTextStyles.labelLargePrimary,
                                                            ),
                                                            CustomImageView(
                                                              imagePath: ImageConstant.imgRightArrow,
                                                              height: 14.h,
                                                              width: 14.h,
                                                              alignment: Alignment.topCenter,
                                                              margin: EdgeInsets.only(left: 4.h),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16.h),
                                            CustomImageView(
                                              imagePath: ImageConstant.imgCancel,
                                              height: 20.h,
                                              width: 20.h,
                                              margin: EdgeInsets.only(top: 4.h),
                                            )
                                          ],
                                        ),
                                      )
                                    ], 
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 70.h),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(
                      left: 344.h,
                      right: 280.h,
                    ),
                    padding: EdgeInsets.only(left: 74.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgWalkingMan,
                          height: 40.h,
                          width: 42.h,
                        )
                      ],
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.img3DCar,
                    height: 40.h,
                    width: 54.h,
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 216.h),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildBottombar(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          Navigator.pushNamed(navigatorKey.currentContext!, getCurrentRoute(type));
        },
      ),
    );
  }

  // Section Widget
  Widget _buildFloatingactionb(BuildContext context){
    return CustomFloatingButton(
      height: 48,
      width: 48,
      backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
      child: CustomImageView(
        imagePath: ImageConstant.imgLocationPrimary,
        height: 24.0.h,
        width: 24.0.h,
      ),
    );
  }

  // Handling route based on bottom click actions 
  String getCurrentRoute(BottomBarEnum type){
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homeOneInitialPage;
      case BottomBarEnum.Route:
        return AppRoutes.myRoutePage;
      case BottomBarEnum.Activity:
        return AppRoutes.homeOneInitialPage;
      case BottomBarEnum.Profile:
        return AppRoutes.myRoutePage;
      default:
      return "/";
    }
  }
}