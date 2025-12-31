import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_search_view.dart';

// ignore for file, class must be immutable
class AddRouteScreen extends StatelessWidget{
  AddRouteScreen({Key? key})
    : super(key: key,);

  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [_buildAddrouteone(context),SizedBox(height: 4.h)],
          ),
        ),
      );
  }

  // Section Widget
  Widget _buildAddrouteone(BuildContext context){
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        top: 24.h,
        bottom: 22.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.08),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 3,),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h),
          CustomAppBar(
            leadingWidth: 40.h,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imgCancel,
              margin: EdgeInsets.only(left: 16.h),
            ),
            centerTitle: true,
            title: AppbarSubtitle(text: "Add Route",),
            actions: [
              AppbarTrailingImage(
                imagePath: ImageConstant.imgPlusBlack,
                margin: EdgeInsets.only(right: 15.h),
              )
            ],
          ),
          SizedBox(height: 22.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      CustomSearchView(
                        controller: locationController,
                        hintText: "Your Location",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.h,
                          vertical: 16.h,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      CustomSearchView(
                        controller: destinationController,
                        hintText: "Destination",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.h,
                          vertical: 16.h,
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
}