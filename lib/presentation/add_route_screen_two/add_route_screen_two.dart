import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/custom_text_form_field.dart';
import 'widgets/add_route_two_item_widget.dart';

// ignore for file, class must be immutable
class AddRouteScreenTwo extends StatelessWidget{
  AddRouteScreenTwo({Key? key})
    : super(key: key,);

  TextEditingController pickupController = TextEditingController();
  TextEditingController addStopController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];
  TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildAddrouteone(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(top: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildColumnmeansof(context),
                        SizedBox(height: 22.h),
                        _buildColumnnumberof(context),
                        SizedBox(height: 4.h)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: _buildButtonnav(context),
      ),
    );
  }

  // Section Widget
  Widget _buildAddrouteone(BuildContext context){
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(top: 24.h),
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
            title: AppbarSubtitle(
              text: "Add Route",
            ),
            actions: [
              AppbarTrailingImage(
                imagePath: ImageConstant.imgPlus,
                margin: EdgeInsets.only(right: 15.h),
              ),
              AppbarTrailingImage(
                imagePath: ImageConstant.imgSetting,
                margin: EdgeInsets.only(
                  left: 22.h,
                  right: 15.h,
                ),
              )
            ],
          ),
          SizedBox(height: 22.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(
              left: 16.h,
              right: 24.h,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomSearchView(
                                controller: addStopController,
                                hintText: "Pickup",
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.h,
                                  vertical: 16.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.h),
                            // CustomImageView(
                            //   imagePath: ImageConstant.imgCancel,
                            //   height: 24.h,
                            //   width: 24.h,
                            // )
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomSearchView(
                                controller: addStopController,
                                hintText: "Add Stop",
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.h,
                                  vertical: 16.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.h),
                            // CustomImageView(
                            //   imagePath: ImageConstant.imgCancel,
                            //   height: 24.h,
                            //   width: 24.h,
                            // )
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomSearchView(
                                controller: destinationController,
                                hintText: "Destination",
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.h,
                                  vertical: 16.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.h),
                            // CustomImageView(
                            //   imagePath: ImageConstant.imgCancel,
                            //   height: 24.h,
                            //   width: 24.h,
                            // )
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h,)
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
  Widget _buildColumnmeansof(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Means of transportation",
                  style: theme.textTheme.labelLarge,
                )
              ],
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 80.h,
            width: 358.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index){
                return AddRouteTwoItemWidget();
              }, 
              separatorBuilder: (context, index){
                return SizedBox(width: 14.h,);
              }, 
              itemCount: 7,
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildColumnnumberof(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type of service",
                      style: CustomTextStyles.labelLargeGray400,
                    ),
                    SizedBox(height: 4.h),
                    CustomDropDown(
                      icon: Container(
                        margin: EdgeInsets.only(left: 16.h),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgBlueGrayDownArrow,
                          height: 16.h,
                          width: 20.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      iconSize: 16.h,
                      hintText: "Type of Service",
                      items: dropdownItemList,
                      contentPadding: EdgeInsets.all(14.h),
                      borderDecoration: DropDownStyleHelper.outlineBlueGray,
                    )
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Departure",
                      style: theme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFormField(
                      readOnly: true,
                      controller: timeController,
                      hintText: "Set time",
                      textInputAction: TextInputAction.done,
                      prefix: Container(
                        margin: EdgeInsets.fromLTRB(14.h, 16.h, 12.h, 16.h),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgClock,
                          height: 16.h,
                          width: 16.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      prefixConstraints: BoxConstraints(
                        maxHeight: 50.h,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.h,
                        vertical: 16.h,
                      ),
                      onTap: () {},
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Section Widget 
  Widget _buildButtonnav(BuildContext context){
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
          top: BorderSide(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomElevatedButton(
            text: "Add route",
            buttonStyle: CustomButtonStyles.fillBlueGray,
          )
        ],
      ),
    );
  }
}