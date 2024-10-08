import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'widgets/set_date_bottomsheet_two_item_widget.dart';

// ignore for file, must be immutable
class SetDateBottomsheetTwo extends StatelessWidget{
  SetDateBottomsheetTwo({Key? key})
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
              top: 10.h,
              right: 16.h,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.customBorderTL24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 4.h),
                SizedBox(
                  width: 50.h,
                  child: Divider(),
                ),
                SizedBox(height: 14.h),
                Text(
                  "Set date",
                  style: CustomTextStyles.titleMediumBlack900,
                ),
                SizedBox(height: 24.h),
                _buildStacktitletwo(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildStacktitletwo(BuildContext context){
    return SizedBox(
      height: 478.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: Column(
                  children: [
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
                          CustomTextFormField(
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
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Repeat every",
                        style: CustomTextStyles.labelLargeGray600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onPrimary.withOpacity(1),
                              borderRadius: BorderRadiusStyle.roundedBorder8,
                              border: Border.all(
                                color: appTheme.gray400,
                                width: 1.h,
                              )
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "1",
                                  style: CustomTextStyles.bodySmallErrorContainer,
                                )
                              ],
                            ),
                          ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "S",
                            style: CustomTextStyles.bodyMediumBluegray800,
                          ),
                          Container(
                            height: 40.h,
                            width: 40.h,
                            margin: EdgeInsets.only(left: 24.h),
                            decoration: BoxDecoration(
                              color: appTheme.deepPurpleA200,
                              borderRadius: BorderRadiusStyle.CircleBorder20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "M",
                                  style: CustomTextStyles.titleSmallInterPrimary,
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 40.h,
                            width: 40.h,
                            margin: EdgeInsets.only(left: 10.h),
                            decoration: BoxDecoration(
                              color: appTheme.deepPurpleA200,
                              borderRadius: BorderRadiusStyle.CircleBorder20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "T",
                                  style: CustomTextStyles.titleSmallInterPrimary,
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 40.h,
                            width: 40.h,
                            margin: EdgeInsets.only(left: 10.h),
                            decoration: BoxDecoration(
                              color: appTheme.deepPurpleA200,
                              borderRadius: BorderRadiusStyle.CircleBorder20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "F",
                                  style: CustomTextStyles.titleSmallInterPrimary,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 24.h),
                            child: Text(
                              "S",
                              style: CustomTextStyles.bodyMediumBluegray800,
                            ),
                          )
                        ],
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
                          CustomTextFormField(
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
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Occurs every Monday through Friday",
                        style: CustomTextStyles.labelLargeErrorContainer,
                      ),
                    )
                  ]
                ),
              ),
              SizedBox(height: 36.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      CustomElevatedButton(
                        text: "Save",
                      ),
                      SizedBox(height: 22.h),
                      Text(
                        "Cancel",
                        style: CustomTextStyles.titleSmallErrorContainerMedium,
                      )
                    ],
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(
                  left: 6.h,
                  right: 8.h,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(1),
                  borderRadius: BorderRadiusStyle.roundedBorder8,
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.gray9000c.withOpacity(0.04),
                      spreadRadius: 2.h,
                      blurRadius: 2.h,
                      offset: Offset(0, 8,),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 30.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 34.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgLeftArrow,
                            height: 20.h,
                            width: 20.h,
                          ),
                          Text(
                            "January 2024",
                            style: CustomTextStyles.titleMediumInterErrorContainer,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgRightArrow1,
                            height: 20.h,
                            width: 20.h,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 32.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mo",
                            style: CustomTextStyles.titleSmallInterErrorContainer,
                          ),
                          Text(
                            "Tu",
                            style: CustomTextStyles.titleSmallInterErrorContainer,
                          ),
                          Text(
                            "We",
                            style: CustomTextStyles.titleSmallInterErrorContainer,
                          ),
                          Text(
                            "Th",
                            style: CustomTextStyles.titleSmallInterErrorContainer,
                          ),
                          Text(
                            "Fr",
                            style: CustomTextStyles.titleSmallInterErrorContainer,
                          ),
                          Text(
                            "Sat",
                            style: CustomTextStyles.titleSmallInterErrorContainer,
                          ),
                          Text(
                            "Su",
                            style: CustomTextStyles.titleSmallInterErrorContainer,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Container(
                      margin: EdgeInsets.only(
                        left: 34.h,
                        right: 40.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusStyle.roundedBorder8,
                      ),
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "26",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          Text(
                            "27",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          Text(
                            "28",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          Text(
                            "29",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          Text(
                            "30",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          Text(
                            "31",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          Text(
                            "1",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24.h,
                        right: 34.h,
                      ),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          return SetDateBottomsheetTwoItemWidget();
                        }, 
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 14.h,);
                        }, 
                        itemCount: 4
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Container(
                      margin: EdgeInsets.only(
                        left: 34.h,
                        right: 38.h,
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadiusStyle.roundedBorder8),
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "30",
                            style: theme.textTheme.bodyMedium,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 28.h),
                            child: Text(
                              "31",
                              style: CustomTextStyles.bodyMediumGray600,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 28.h),
                            child: Text(
                              "1",
                              style: CustomTextStyles.bodyMediumGray600,
                            ),
                          ),
                          Spacer(
                            flex: 26,
                          ),
                          Text(
                            "2",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          Spacer(
                            flex: 24,
                          ),
                          Text(
                            "3",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          Spacer(
                            flex: 24,
                          ),
                          Text(
                            "4",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                          Spacer(
                            flex: 24,
                          ),
                          Text(
                            "5",
                            style: CustomTextStyles.bodyMediumGray600,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 26.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: Divider(color: appTheme.indigo5001),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
}