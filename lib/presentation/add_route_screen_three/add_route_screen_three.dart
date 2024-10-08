import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_radio_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'widgets/add_route_three_widget.dart';

// ignore for file: must be immutable
class AddRouteScreenThree extends StatelessWidget{
  AddRouteScreenThree({Key? key})
    : super(key: key,);

  String radioGroup = "";
  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  List<String> dropdownItemList1 = ["Repeat", "Does not repeat"];
  String doyouwantto = "";
  TextEditingController timeoneController = TextEditingController();
  TextEditingController timetwoController = TextEditingController();

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
                        SizedBox(
                          width: double.maxFinite,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildColumnnumberof(context),
                                  SizedBox(height: 24.h),
                                  _buildDepartureone(context),
                                  SizedBox(height: 22.h),
                                  Text(
                                    "Do you want to make a returning route?",
                                    style: theme.textTheme.labelLarge,
                                  ),
                                  SizedBox(height: 10.h),
                                  _buildDoyouwantto(context),
                                  SizedBox(height: 22.h),
                                  _buildColumnreturn(context),
                                  SizedBox(height: 24.h),
                                  _buildColumntimerange(context)
                                ],
                              ),
                            ),
                          ),
                        ),
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
      )
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
              imagePath: ImageConstant.imgLeftArrow1,
              margin: EdgeInsets.only(left: 16.h),
            ),
            centerTitle: true,
            title: AppbarSubtitle(
              text: "Add Route",
            ),
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
                      CustomRadioButton(
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
                        }
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: CustomRadioButton(
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

  // Section Widget
  Widget _buildColumnmeansof(BuildContext context){
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
              itemBuilder: (context, index) {
                return AddRouteThreeWidget();
              }, 
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: 14.h,
                );
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
            hintText: "Type of service",
            items: dropdownItemList,
            contentPadding: EdgeInsets.all(14.h),
            borderDecoration: DropDownStyleHelper.outlineBlueGray,
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildData(BuildContext context){
    return CustomTextFormField(
      readOnly: true,
      controller: dateController,
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
      prefixConstraints: BoxConstraints(
        maxHeight: 50.h,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 16.h,
      ),
      onTap: () {},
    );
  }

  // Section Widget
  Widget _buildTime(BuildContext context){
    return CustomTextFormField(
      readOnly: true,
      controller: timeController,
      hintText: "Set time",
      prefix: Container(
        margin: EdgeInsets.fromLTRB(14.h, 16.h, 12.h, 16.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgClock,
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
  Widget _buildDepartureone(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Departure",
            style: theme.textTheme.labelLarge,
          ),
          SizedBox(height: 14.h),
          _buildData(context),
          SizedBox(height: 14.h),
          _buildTime(context),
          SizedBox(height: 14.h),
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
            hintText: "Does not repeat",
            hintStyle: CustomTextStyles.bodySmallErrorContainer,
            items: dropdownItemList1,
            prefix: Container(
              margin: EdgeInsets.fromLTRB(14.h, 16.h, 12.h, 16.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgRepeat,
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
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildDoyouwantto(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          CustomRadioButton(
            text: "Yes",
            value: "Yes",
            groupValue: doyouwantto,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            textStyle: theme.textTheme.labelLarge,
            onChange: (value) {
              doyouwantto = value;
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: CustomRadioButton(
              text: "No",
              value: "No",
              groupValue: doyouwantto,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              textStyle: theme.textTheme.labelLarge,
              onChange: (value) {
                doyouwantto = value;
              },
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildGateway(BuildContext context){
    return CustomElevatedButton(
      text: "Gateway Zone, Magodo Phase II, GRA Lagos State",
      leftIcon: Container(
        margin: EdgeInsets.only(right: 12.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgSearch,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillGray,
      buttonTextStyle: CustomTextStyles.bodySmallOnPrimaryContainer,
    );
  }

  // Section Widget
  Widget _buildColumnreturn(BuildContext context){
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Return Destination",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(height: 4.h),
          _buildGateway(context)
        ],
      ),
    );
  }

  // Section Wigdet
  Widget _buildTimeone(BuildContext context){
    return CustomTextFormField(
      readOnly: true,
      width: 148.h,
      controller: timeController,
      hintText: "Set time",
      prefix: Container(
        margin: EdgeInsets.fromLTRB(14.h, 14.h, 12.h, 14.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgClock,
          height: 16.h,
          width: 16.h,
          fit: BoxFit.contain,
        ),
      ),
      prefixConstraints: BoxConstraints(maxHeight: 46.h),
      contentPadding: EdgeInsets.all(14.h),
      onTap: () {},
    );
  }

  // Section Widget 
  Widget _buildTImetwo(BuildContext context){
    return Expanded(
      child: CustomTextFormField(
        readOnly: true,
        controller: timeController,
        hintText: "Set time",
        textInputAction: TextInputAction.done,
        prefix: Container(
          margin: EdgeInsets.fromLTRB(14.h, 14.h, 12.h, 14.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgClock,
            height: 16.h,
            width: 16.h,
            fit: BoxFit.contain,
          ),
        ),
        prefixConstraints: BoxConstraints(maxHeight: 46.h),
        contentPadding: EdgeInsets.all(14.h),
        onTap: () {},
      ),
    );
  }

  // Section Widget
  Widget _buildColumntimerange(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Time Range",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                _buildTimeone(context),
                SizedBox(width: 14.h),
                Expanded(
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgRightArrow,
                        height: 16.h,
                        width: 16.h,
                      ),
                      SizedBox(width: 14.h),
                      _buildTImetwo(context)
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
  Widget _buildAddroute(BuildContext context){
    return CustomElevatedButton(
      text: "Add route",
      buttonStyle: CustomButtonStyles.fillBlueGray,
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
        children: [_buildAddroute(context)],
      ),
    );
  }
}