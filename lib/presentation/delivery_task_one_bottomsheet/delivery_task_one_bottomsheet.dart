import 'package:flutter/material.dart';
import 'package:new_project/presentation/delivery_task_one_bottomsheet/widgets/delivery_task_one_bottomsheet_widget.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_radio_button.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

// ignore for file, must be immutable
class DeliveryTaskOneBottomsheet extends StatelessWidget{
  DeliveryTaskOneBottomsheet({Key? key})
    : super(key: key,);

  TextEditingController itemController = TextEditingController();
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
                _buildColumnlineone(context),
                SizedBox(height: 30.h),
                SizedBox(
                  height: 642.h,
                  width: double.maxFinite,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Expires in 01:00",
                              style: CustomTextStyles.bodyMediumMulishGray800,
                            ),
                            SizedBox(height: 28.h),
                            _buildRowname(context),
                            SizedBox(height: 16.h),
                            Container(
                              width: 320.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.h,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: appTheme.deepPurple50,
                                borderRadius: BorderRadiusStyle.roundedBorder4,
                              ),
                              child: Text(
                                "1234 movers are heading to the same destination",
                                style: CustomTextStyles.bodySmallDeeppurple600,
                                textAlign: TextAlign.center,
                              )
                            ),
                            SizedBox(height: 16.h),
                            _buildGroup(context),
                            SizedBox(height: 14.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Price",
                                style: CustomTextStyles.labelLargeGray600,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            CustomTextFormField(
                              controller: priceController,
                              hintText: "NGN",
                              hintStyle: theme.textTheme.bodySmall!,
                              textInputAction: TextInputAction.done,
                              contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                            ),
                            SizedBox(height: 8.h),
                            _buildPrices(context),
                            SizedBox(height: 40.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Item Image",
                                style: theme.textTheme.labelLarge,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            CustomImageView(
                              imagePath: ImageConstant.imgShoes,
                              height: 164.h,
                              width: double.maxFinite,
                              radius: BorderRadius.circular(8.h),
                            ),
                            // SizedBox(height: 4.h),
                            // CustomImageView(
                            //   imagePath: ImageConstant.imgSearch,
                            //   height: 24.h,
                            //   width: 24.h,
                            //   alignment: Alignment.centerLeft,
                            // ),
                            Text(
                              "Item Description",
                              style: theme.textTheme.labelLarge,
                            ),
                            SizedBox(height: 16.h),
                            CustomTextFormField(
                              controller: itemController,
                              hintText: "Enter the item description",
                              hintStyle: theme.textTheme.bodySmall,
                              textInputAction: TextInputAction.done,
                              contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                              textStyle: CustomTextStyles.bodySmallGray800,
                            )
                          ],
                        ),
                      ),
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

  // Section Widget
  Widget _buildColumnlineone(BuildContext context){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(
            width: 50.h,
            child: Divider(),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Delivery task",
                  style: CustomTextStyles.titleMediumGray80001,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgCancel,
                  height: 24.h,
                  width: 24.h,
                  margin: EdgeInsets.only(left: 98.h),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section Widget 
  Widget _buildRowname(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgProfile,
            height: 50.h,
            width: 50.h,
            radius: BorderRadius.circular(24.h,),
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 18.h),
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
                              borderRadius: BorderRadius.circular(1.h),
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
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 18.h),
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            decoration: BoxDecoration(
              color: appTheme.lightGreen500,
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 1.5.h),
                Text(
                  "Light",
                  style: CustomTextStyles.labelMediumInterOnPrimary,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section WIdget 
  Widget _buildGroup(BuildContext context){
    return SizedBox(
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
              text: "Gateway Zone, Magodo Phase II, GRA Lagos State",
              value: "Gateway Zone, Magodo Phase II, GRA Lagos State",
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
    );
  }

  // Section Wigdet
  Widget _buildPrices(BuildContext context){
    return SizedBox(
      height: 28.h,
      width: 250.h,
      child: ListView.separated(
        padding: EdgeInsets.only(right: 92.h),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return DeliveryTaskOneBottomsheetWidget();
        }, 
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 12.h,
          );
        }, 
        itemCount: 4,
      ),
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.fromLTRB(16.h, 22.h, 16.h, 24.h),
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
          children: [
            CustomElevatedButton(
              text: "Bid Price",
              buttonStyle: CustomButtonStyles.fillBlueGray,
            )
          ],
        ),
      ),
    );
  }
}