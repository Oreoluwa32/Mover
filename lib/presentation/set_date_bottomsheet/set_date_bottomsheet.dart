import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'widgets/chipviewone_item_widget.dart';

// ignore for file, class must be immutable
class SetDateBottomsheet extends StatelessWidget{
  SetDateBottomsheet({Key? key})
    : super(key: key,);

  TextEditingController startdateController = TextEditingController();
  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];
  TextEditingController enddateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 16.h,
              top: 16.h,
              right: 16.h,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.customBorderTL24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildColumnlineone(context),
                SizedBox(height: 36.h),
                _buildColumnsave(context),
                SizedBox(height: 6.h)
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildDate(BuildContext context){
    return CustomTextFormField(
      readOnly: true,
      controller: startdateController,
      hintText: "Set date",
      prefix: Container(
        margin: EdgeInsets.fromLTRB(14.h, 16.h, 12.h, 16.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgCalendar,
          height: 16.h,
          width: 16.h,
          fit: BoxFit.contain,
        ),
      ),
      prefixConstraints: BoxConstraints(maxHeight: 50.h),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 16.h,
      ),
      onTap: () {},
    );
  }

  // Section Widget
  Widget _buildOnetwo(BuildContext context){
    return CustomOutlinedButton(
      width: 50.h,
      text: "1",
      buttonStyle: CustomButtonStyles.outlineGray,
      buttonTextStyle: CustomTextStyles.bodySmallErrorContainer,
    );
  }

  // Section Widget
  Widget _buildDateone(BuildContext context){
    return CustomTextFormField(
      readOnly: true,
      controller: enddateController,
      hintText: "Set date",
      textInputAction: TextInputAction.done,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(14.h, 16.h, 12.h, 16.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgCalendar,
          height: 16.h,
          width: 16.h,
          fit: BoxFit.contain,
        ),
      ),
      prefixConstraints: BoxConstraints(maxHeight: 50.h),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 16.h,
      ),
      onTap: () {},
    );
  }

  // Section Widget
  Widget _buildColumnlineone(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 50.h,
              child: Divider(),
            ),
          ),
          SizedBox(height: 14.h),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Set date",
              style: CustomTextStyles.titleMediumBlack900,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Start date",
                  style: CustomTextStyles.labelLargeGray600,
                ),
                SizedBox(height: 4.h),
                _buildDate(context)
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Repeat every",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                _buildOnetwo(context),
                SizedBox(width: 16.h),
                Expanded(
                  child: CustomDropDown(
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
                    hintText: "Week",
                    hintStyle: CustomTextStyles.bodySmallErrorContainer,
                    items: dropdownItemList,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.h,
                      vertical: 16.h,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(
              left: 14.h,
              right: 18.h,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                direction: Axis.horizontal,
                runSpacing: 10.h,
                spacing: 10.h,
                children: List<Widget>.generate(7, (index) => ChipviewoneItemWidget()),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "End date",
                  style: CustomTextStyles.labelLargeGray600,
                ),
                SizedBox(height: 4.h),
                _buildDateone(context)
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            "Occurs every Monday through Friday",
            style: CustomTextStyles.labelLargeErrorContainer,
          )
        ],
      ),
    );
  }

  // Section Widget 
  Widget _buildSave(BuildContext context){
    return CustomElevatedButton(text: "Save",);
  }

  // Section Widget
  Widget _buildColumnsave(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          _buildSave(context),
          SizedBox(height: 22.h),
          Text(
            "Cancel",
            style: CustomTextStyles.titleSmallErrorContainer,
          )
        ],
      ),
    );
  }
}