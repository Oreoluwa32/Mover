import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_radio_button.dart';
import '../../widgets/custom_text_form_field.dart';

// ignore for filw, class must be immutabel
class RideSharingTaskBottomsheetOne extends StatelessWidget{
  RideSharingTaskBottomsheetOne({Key? key})
    : super(key: key,);

  TextEditingController routeController = TextEditingController();
  String radioGroup = "";
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.customBorderTL24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                _buildColumnline(context),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 745.h, //height is 470 originally
                  width: double.maxFinite,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      _buildColumnexpires(context),
                      _buildButtonnav(context)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Widhet
  Widget _buildColumnline(BuildContext context){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(
            width: 50.h,
            child: Divider(),
          ),
          SizedBox(height: 14.h),
          Text(
            "Ride sharing task",
            style: CustomTextStyles.titleMediumGray80001,
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildExpiresin(BuildContext context){
    return CustomElevatedButton(
      height: 30.h,
      width: 136.h,
      text: "Expires in 01:00",
      buttonStyle: CustomButtonStyles.fillRed,
      buttonTextStyle: CustomTextStyles.bodySmallRedA700,
    );
  }

  // Section Widget
  Widget _buildRoute(BuildContext context){
    return CustomTextFormField(
      controller: routeController,
      hintText: "1234 movers are heading to the same destination",
      hintStyle: CustomTextStyles.bodySmallDeeppurple600,
      contentPadding: EdgeInsets.fromLTRB(22.h, 14.h, 22.h, 10.h),
      borderDecoration: TextFormFieldStyleHelper.fillDeepPurple,
      fillColor: appTheme.deepPurple50,
    );
  }

  // Section Widget
  Widget _buildPrice(BuildContext context){
    return CustomTextFormField(
      controller: priceController,
      hintText: "NGN",
      hintStyle: theme.textTheme.bodySmall,
      contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
      textInputAction: TextInputAction.done,
    );
  }

  // Section Widget
  Widget _buildColumnexpires(BuildContext context){
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildExpiresin(context),
            SizedBox(height: 14.h),
            SizedBox(
              width: double.maxFinite,
              child: Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgProfile,
                    height: 50.h,
                    width: 50.h,
                    radius: BorderRadius.circular(24.h),
                  ),
                  SizedBox(width: 18.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "John Doe",
                          style: CustomTextStyles.bodyMediumMulishGray800,
                        ),
                        SizedBox(height: 4.h),
                        SizedBox(
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              Text(
                                "10m away",
                                style: CustomTextStyles.bodySmallInterGray600,
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 2.h,
                                  width: 2.h,
                                  margin: EdgeInsets.only(
                                    left: 4.h,
                                    top: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: appTheme.gray700,
                                    borderRadius: BorderRadius.circular(1.h,),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.h),
                                child: Text(
                                  "2mins",
                                  style: CustomTextStyles.bodySmallInterGray600,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        SizedBox(
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgUsers,
                                height: 12.h,
                                width: 12.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.h),
                                child: Text(
                                  "3 passenger capacity",
                                  style: CustomTextStyles.bodySmallInterGray600,
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
            ),
            SizedBox(height: 12.h),
            _buildRoute(context),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  CustomRadioButton(
                    text: "Muritala Mohammed Airport",
                    value: "Muritala Mohammed Airport",
                    groupValue: radioGroup,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.h,
                      vertical: 14.h,
                    ),
                    decoration: RadioStyleHelper.fillOnPrimary,
                    onChange: (value) {
                      radioGroup = value;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: CustomRadioButton(
                      text: "Gatetway Zone, Magodo Phase II, GRA Lagos State",
                      value: "Gatetway Zone, Magodo Phase II, GRA Lagos State",
                      groupValue: radioGroup,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.h,
                        vertical: 14.h,
                      ),
                      decoration: RadioStyleHelper.fillOnPrimary,
                      onChange: (value) {
                        radioGroup = value;
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Price",
                style: CustomTextStyles.labelLargeGray600,
              ),
            ),
            SizedBox(height: 4.h),
            _buildPrice(context)
          ],
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildBidprice(BuildContext context){
    return CustomElevatedButton(
      text: "Bid Price",
      buttonStyle: CustomButtonStyles.fillBlueGray,
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context){
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.h, 20.h, 16.h, 22.h),
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBidprice(context),
          SizedBox(height: 22.h),
          Text(
            "Decline",
            style: CustomTextStyles.titleSmallRedA700,
          )
        ],
      ),
    );
  }
}