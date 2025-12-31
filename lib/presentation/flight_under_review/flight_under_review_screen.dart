import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class FlightUnderReviewScreen extends StatelessWidget{
  const FlightUnderReviewScreen({Key? key})
    : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: 20.h,
                  top: 124.h,
                  right: 20.h,
                ),
                child: Column(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgAlarmClock,
                      height: 170.h,
                      width: 170.h,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Request under review",
                      style: CustomTextStyles.titleMediumGray8000118,
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      "Your flight log is under review and you can expect a notification within the next 3-5 minutes.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.bodyMediumMulishGray800.copyWith(height: 1.50,),
                    ),
                    SizedBox(height: 4.h)
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }
}