import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_project/presentation/delivery_task_one_bottomsheet/delivery_task_one_bottomsheet.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_icon_button.dart';
import 'models/home_initial_model.dart';
import 'notifier/home_notifier.dart';

class HomeOneInitialPage extends StatefulWidget{
  const HomeOneInitialPage({Key? key})
    :super(key: key,
    );

  @override
  HomeOneInitialPageState createState() => HomeOneInitialPageState();
}

// ignore for file: must be immutabel
class HomeOneInitialPageState extends State<HomeOneInitialPage>{
  Completer<GoogleMapController> googleMapController = Completer();
  Completer<GoogleMapController> googleMapController1 = Completer();

  @override
  Widget build(BuildContext context){
    return Container(
      height: 691.83.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(color: theme.colorScheme.onPrimary.withOpacity(1),),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      height: 1148.h,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          _buildHorizontalscrol(context),
                          _buildHorizontalscrol1(context),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          _buildFloatingactionb(context)
        ],
      ),
    );
  }

  // Section widget 
  Widget _buildHorizontalscrol(BuildContext context){
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: SizedBox(
            height: 852.h,
            width: 968.h,
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
        ),
      ),
    );
  }

  // Section Widget 
  Widget _buildHorizontalscrol1(BuildContext context){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: SizedBox(
          height: 1148.h,
          width: 968.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 1148.h,
                width: 968.h,
                decoration: BoxDecoration(color: theme.colorScheme.onPrimary.withOpacity(1),),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      height: 852.h,
                      width: 968.h,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            37.43296265331129, 
                            -122.08832357078792,
                          ),
                          zoom: 14.4746,
                        ),
                        onMapCreated: (GoogleMapController controller){
                          googleMapController1.complete(controller);
                        },
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: false,
                      ),
                    ),
                          SizedBox(height: 24.h,),
                          liveRoute(context),
                          SizedBox(height: 24.h,),
                          tasks(context),
                    SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 1202.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.img3DCar,
                                  height: 10.h,
                                  width: 54.h,
                                  margin: EdgeInsets.only(left: 562.h),
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.img3DCar,
                                  height: 40.h,
                                  width: 58.h,
                                  alignment: Alignment.center,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(
                              left: 344.h,
                              right: 312.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                SizedBox(height: 10.h),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 34.h,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.h,
                                            vertical: 10.h,
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
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CustomImageView(
                                                imagePath: ImageConstant.imgWalking,
                                                height: 18.h,
                                                width: double.maxFinite,
                                              ),
                                              Text(
                                                "PT",
                                                style: CustomTextStyles.interErrorContainer,
                                              ),
                                              SizedBox(height: 14.h),
                                              CustomImageView(
                                                imagePath: ImageConstant.imgBike,
                                                height: 18.h,
                                                width: double.maxFinite,
                                              ),
                                              Text(
                                                "Bike",
                                                style: CustomTextStyles.interErrorContainer,
                                              ),
                                              SizedBox(height: 14.h),
                                              CustomImageView(
                                                imagePath: ImageConstant.imgCar,
                                                height: 18.h,
                                                width: double.maxFinite,
                                              ),
                                              Text(
                                                "Car",
                                                style: CustomTextStyles.interErrorContainer,
                                              ),
                                              SizedBox(height: 14.h),
                                              CustomImageView(
                                                imagePath: ImageConstant.imgPlane,
                                                height: 18.h,
                                                width: double.maxFinite,
                                              ),
                                              Text(
                                                "Plane",
                                                style: CustomTextStyles.interErrorContainer,
                                              ),
                                              SizedBox(height: 14.h),
                                              CustomImageView(
                                                imagePath: ImageConstant.imgTruck,
                                                height: 18.h,
                                                width: double.maxFinite,
                                              ),
                                              Text(
                                                "Truck",
                                                style: CustomTextStyles.interErrorContainer,
                                              ),
                                              SizedBox(height: 14.h),
                                              CustomImageView(
                                                imagePath: ImageConstant.imgBus,
                                                height: 18.h,
                                                width: double.maxFinite,
                                              ),
                                              Text(
                                                "Bus",
                                                style: 
                                                CustomTextStyles.interErrorContainer,
                                              ),
                                              SizedBox(height: 14.h),
                                              CustomImageView(
                                                imagePath: ImageConstant.imgTrain,
                                                height: 18.h,
                                                width: double.maxFinite,
                                              ),
                                              Text(
                                                "Train",
                                                style: CustomTextStyles.interErrorContainer,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      CustomImageView(
                                        imagePath: ImageConstant.imgWalkingMan,
                                        height: 18.h,
                                        width: 10.h,
                                        margin: EdgeInsets.only(
                                          left: 8.h,
                                          top: 104.h,
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: 34.h),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomImageView(
                                                  imagePath: ImageConstant.imgWalkingLady,
                                                  height: 40.h,
                                                  width: 28.h,
                                                  margin: EdgeInsets.only(left: 48.h),
                                                ),
                                                SizedBox(height: 30.h),
                                                SizedBox(
                                                  width: double.maxFinite,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CustomImageView(
                                                        imagePath: ImageConstant.imgWalkingLady,
                                                        height: 40.h,
                                                        width: 28.h,
                                                        margin: EdgeInsets.only(
                                                          left: 48.h,
                                                          bottom: 36.h,
                                                        ),
                                                      ),
                                                      CustomImageView(
                                                        imagePath: ImageConstant.img3DCar,
                                                        height: 40.h,
                                                        width: 58.h,
                                                        alignment: Alignment.bottomCenter,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 30.h),
                                                CustomImageView(
                                                  imagePath: ImageConstant.imgWalkingLady,
                                                  height: 40.h,
                                                  width: 28.h,
                                                  alignment: Alignment.centerRight,
                                                  margin: EdgeInsets.only(right: 78.h),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgWalkingLady,
                                height: 40.h,
                                width: 28.h,
                                margin: EdgeInsets.only(
                                  top: 24.h,
                                  bottom: 8.h,
                                ),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgWalkingLady,
                                height: 40.h,
                                width: 28.h,
                                margin: EdgeInsets.only(
                                  left: 158.h,
                                  bottom: 8.h,
                                ),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgWalkingLady,
                                height: 40.h,
                                width: 28.h,
                                margin: EdgeInsets.only(
                                  left: 158.h,
                                  bottom: 8.h,
                                ),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgWalkingMan,
                                height: 40.h,
                                width: 42.h,
                                alignment: Alignment.topCenter,
                                margin: EdgeInsets.only(left: 2.h),
                              ),
                            ],
                          ),
                          SizedBox(height: 88.h),
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(
                              left: 344.h,
                              right: 280.h,
                            ),
                            padding: EdgeInsets.only(left: 54.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgWalkingLady,
                                  height: 40.h,
                                  width: 42.h,
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.only(right: 14.h),
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.imgWalkingMan,
                                  height: 40.h,
                                  width: 58.h,
                                ),
                                SizedBox(height: 70.h),
                                CustomImageView(
                                  imagePath: ImageConstant.imgWalkingLady,
                                  height: 40.h,
                                  width: 42.h,
                                  margin: EdgeInsets.only(left: 20.h),
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
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 40.h,
                  margin: EdgeInsets.only(top: 48.h),
                  padding: EdgeInsets.symmetric(horizontal: 280.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomFloatingButton(
                        height: 40,
                        width: 40,
                        backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
                        decoration: FloatingButtonStyleHelper.fillOnPrimary,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgFilter,
                          height: 20.0.h,
                          width: 20.0.h,
                        ),
                      ),
                      CustomFloatingButton(
                        height: 40,
                        width: 40,
                        backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
                        decoration: FloatingButtonStyleHelper.fillOnPrimary,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgNotificationBell,
                          height: 20.0.h,
                          width: 20.0.h,
                        ),
                      ),
                      SizedBox(height: 24.h,),
                      Padding(
                        padding: EdgeInsets.all(2.h),
                        child: Consumer(
                          builder: (context, ref, _) {
                            return Switch(
                              value: ref.watch(homeNotifier).isSelectedSwitch ?? false, 
                              onChanged: (value) {
                                ref.read(homeNotifier.notifier).changeSwitchBox(value);
                              },
                            );
                          }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget liveRoute(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 12.h
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        borderRadius: BorderRadiusStyle.roundedBorder8,
        boxShadow: [
          BoxShadow(
            color: appTheme.gray9000c,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 4),
          )
        ]
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            decoration: BoxDecoration(
              color: appTheme.lightGreen100,
              borderRadius: BorderRadiusStyle.CircleBorder20,
              border: Border.all(
                color: appTheme.green50,
                width: 6.h,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgCheckCircle,
                  height: 20.h,
                  width: 20.h,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: Text(
              "Your route is now live",
              style: CustomTextStyles.titleSmallInter,
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgCancel,
            height: 20.h,
            width: 20.h,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(
              top: 4.h, 
              right: 4.h
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget tasks(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
              vertical: 12.h
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.roundedBorder8,
              boxShadow: [
                BoxShadow(
                  color: appTheme.gray9000c,
                  spreadRadius: 2.h,
                  blurRadius: 2.h,
                  offset: Offset(0, 4),
                )
              ]
            ),
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconButton(
                  height: 40.h,
                  width: 40.h,
                  padding: EdgeInsets.all(10.h),
                  decoration: IconButtonStyleHelper.outlineDeepPurple,
                  child: CustomImageView(imagePath: ImageConstant.imgPackage,),
                ),
                SizedBox(width: 16.h),
                SizedBox(width: 16.h,),
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
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context, 
                                  builder: (_) => DeliveryTaskOneBottomsheet(),
                                  isScrollControlled: true,
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "View details",
                                    style: CustomTextStyles.labelLargePrimary,
                                  ),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgPurpleRightArrow,
                                    height: 14.h,
                                    width: 14.h,
                                    alignment: Alignment.topCenter,
                                    margin: EdgeInsets.only(left: 4.h),
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
                SizedBox(width: 16.h,),
                SizedBox(width: 16.h,),
                CustomImageView(
                  imagePath: ImageConstant.imgCancel,
                  height: 20.h,
                  width: 20.h,
                  margin: EdgeInsets.only(
                    top: 4.h
                  ),
                )
              ],
            ),
          )
        )
      ],
    );
  }

  // Section Widget 
  Widget _buildFloatingactionb(BuildContext context){
    return CustomFloatingButton(
      height: 48,
      width: 48,
      backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
      alignment: Alignment.bottomRight,
      child: CustomImageView(
        imagePath: ImageConstant.imgLocationPrimary,
        height: 24.0.h,
        width: 24.0.h,
      ),
    );
  }
}