import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_icon_button.dart';

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
                          _buildHorizontalscrol1(context)
                          // Container(
                          //   height: SizeUtils.height,
                          //   child: Stack(
                          //     alignment: Alignment.center,
                          //     children: [
                          //       Container(
                          //         height: SizeUtils.height,
                          //         width: 374.h,
                          //         decoration: AppDecoration.shadowx1,
                          //         child: Stack(
                          //           alignment: Alignment.center,
                          //           children: [
                          //             _buildMapofthree(context),
                          //             Align(
                          //               alignment: Alignment.topCenter,
                          //               child: Column(
                          //                 mainAxisSize: MainAxisSize.min,
                          //                 children: [
                          //                   _buildColumnview(context),
                          //                   SizedBox(height: 24.h),
                          //                   _buildRow(context),
                          //                   SizedBox(height: 34.h),
                          //                   _buildRowspacer(context),
                          //                   SizedBox(height: 96.h),
                          //                   _buildRowspacerthree(context),
                          //                   SizedBox(height: 70.h),
                          //                   _buildColumn(context)
                          //                 ],
                          //               ),
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //       _buildFloatingactionb(context)
                          //     ],
                          //   ),
                          // )
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
                    Column(
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
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Section Widget 
  // Widget _buildColumnview(BuildContext context){
  //   return Container(
  //     width: double.maxFinite,
  //     margin: EdgeInsets.symmetric(horizontal: 16.h),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CustomImageView(
  //           imagePath: ImageConstant.img3DCar,
  //           height: 10.h,
  //           width: 54.h,
  //           alignment: Alignment.centerRight,
  //           margin: EdgeInsets.only(right: 68.h),
  //         ),
  //         SizedBox(height: 38.h),
  //         SizedBox(
  //           width: double.maxFinite,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Container(
  //                 width: 146.h,
  //                 margin: EdgeInsets.only(left: 44.h),
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: 16.h,
  //                   vertical: 6.h,
  //                 ),
  //                 decoration: AppDecoration.black50.copyWith(
  //                   borderRadius: BorderRadiusStyle.roundedBorder12,
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Container(
  //                       height: 6.h,
  //                       width: 6.h,
  //                       decoration: BoxDecoration(
  //                         color: appTheme.redA700,
  //                         borderRadius: BorderRadius.circular(3.h,),
  //                       ),
  //                     ),
  //                     SizedBox(width: 6.h),
  //                     Text(
  //                       "1000+ routes are live",
  //                       style: CustomTextStyles.labelMediumOnPrimary,
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               CustomIconButton(
  //                 height: 40.h,
  //                 width: 40.h,
  //                 padding: EdgeInsets.all(10.h),
  //                 decoration: IconButtonStyleHelper.outlineBlack,
  //                 child: CustomImageView(
  //                   imagePath: ImageConstant.imgNotificationBell,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: 56.h),
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingLady,
  //           height: 40.h,
  //           width: 28.h,
  //           margin: EdgeInsets.only(left: 102.h),
  //         ),
  //         SizedBox(height: 10.h),
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingMan,
  //           height: 18.h,
  //           width: 10.h,
  //           margin: EdgeInsets.only(left: 42.h),
  //         ),
  //         SizedBox(height: 8.h),
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingLady,
  //           height: 40.h,
  //           width: 28.h,
  //           margin: EdgeInsets.only(left: 102.h),
  //         ),
  //         CustomImageView(
  //           imagePath: ImageConstant.img3DCar,
  //           height: 40.h,
  //           width: 58.h,
  //           alignment: Alignment.centerRight,
  //           margin: EdgeInsets.only(right: 30.h),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // // Section Widget 
  // Widget _buildRow(BuildContext context){
  //   return SizedBox(
  //     width: double.maxFinite,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingLady,
  //           height: 40.h,
  //           width: 28.h,
  //         ),
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingLady,
  //           height: 40.h,
  //           width: 28.h,
  //           margin: EdgeInsets.only(right: 126.h),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // // Section Widget 
  // Widget _buildRowspacer(BuildContext context){
  //   return SizedBox(
  //     width: double.maxFinite,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: [
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingMan,
  //           height: 40.h,
  //           width: 42.h,
  //           alignment: Alignment.topCenter,
  //           margin: EdgeInsets.only(
  //             top: 4.h,
  //             bottom: 20.h,
  //           ),
  //         ),
  //         Spacer(
  //           flex: 34,
  //         ),
  //         SizedBox(height: 56.h),
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingLady,
  //           height: 40.h,
  //           width: 28.h,
  //         ),
  //         Spacer(
  //           flex: 32,
  //         ),
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingLady,
  //           height: 40.h,
  //           width: 28.h,
  //         ),
  //         Spacer(
  //           flex: 32,
  //         ),
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingLady,
  //           height: 40.h,
  //           width: 28.h,
  //         ),
  //         SizedBox(height: 56.h),
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingMan,
  //           height: 40.h,
  //           width: 42.h,
  //           alignment: Alignment.topCenter,
  //           margin: EdgeInsets.only(left: 2.h),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // // Section Widget 
  // Widget _buildRowspacerthree(BuildContext context){
  //   return Container(
  //     width: double.maxFinite,
  //     margin: EdgeInsets.only(left: 70.h),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: [
  //         CustomImageView(
  //           imagePath: ImageConstant.img3DCar,
  //           height: 40.h,
  //           width: 58.h,
  //           margin: EdgeInsets.only(top: 42.h),
  //         ),
  //         Spacer(
  //           flex: 19,
  //         ),
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingMan,
  //           height: 40.h,
  //           width: 42.h,
  //           alignment: Alignment.topCenter,
  //         ),
  //         Spacer(
  //           flex: 80,
  //         ),
  //         CustomImageView(
  //           imagePath: ImageConstant.img3DCar,
  //           height: 40.h,
  //           width: 58.h,
  //         )
  //       ],
  //     ),
  //   );
  // }

  // // Section Widget 
  // Widget _buildColumn(BuildContext context){
  //   return Container(
  //     width: double.maxFinite,
  //     margin: EdgeInsets.symmetric(horizontal: 16.h),
  //     padding: EdgeInsets.only(left: 74.h),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CustomImageView(
  //           imagePath: ImageConstant.imgWalkingMan,
  //           height: 40.h,
  //           width: 42.h,
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Section Widget 
  // Widget _buildFloatingactionb(BuildContext context){
  //   return CustomFloatingButton(
  //     height: 40,
  //     width: 40,
  //     backgroundColor: theme.colorScheme.onPrimary,
  //     decoration: FloatingButtonStyleHelper.fillOnPrimary,
  //     alignment: Alignment.topLeft,
  //     child: CustomImageView(
  //       imagePath: ImageConstant.imgFilter,
  //       height: 20.0.h,
  //       width: 20.0.h,
  //     ),
  //   );
  // }

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