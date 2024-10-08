import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';

// ignore for file, class must be immutable
class VehicleInformationScreen extends StatelessWidget{
  VehicleInformationScreen({Key? key})
    : super(key: key,);

  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];
  List<String> dropdownItemList1 = ["Item One", "Item Two", "Item Three"];
  List<String> dropdownItemList2 = ["Item One", "Item Two", "Item Three"];

  TextEditingController plateNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                left: 14.h,
                top: 32.h,
                right: 14.h,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 292.h,
                          child: Text(
                            "Complete the necessary field to validate your vehicle",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.titleSmallGray600Medium.copyWith(height: 1.20,),
                          ),
                        ),
                        SizedBox(height: 28.h),
                        Text(
                          "Vehicle Type",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 4.h),
                        CustomDropDown(
                          icon: Container(
                            margin: EdgeInsets.only(left: 16.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgBlueGrayDownArrow,
                              height: 16.h,
                              width: 18.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          iconSize: 16.h,
                          hintText: "Type of Vehicle",
                          hintStyle: CustomTextStyles.bodyMediumMulishBluegray400,
                          items: dropdownItemList,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.h,
                            vertical: 16.h,
                          ),
                        ),
                        SizedBox(height: 22.h),
                        Text(
                          "Vehicle Brand",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 6.h),
                        CustomDropDown(
                          icon: Container(
                            margin: EdgeInsets.only(left: 16.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgBlueGrayDownArrow,
                              height: 16.h,
                              width: 18.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          iconSize: 16.h,
                          hintText: "Brand of Vehicle",
                          hintStyle: CustomTextStyles.bodyMediumMulishBluegray400,
                          items: dropdownItemList1,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.h,
                            vertical: 16.h,
                          ),
                        ),
                        SizedBox(height: 22.h),
                        Text(
                          "Vehicle Color",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 6.h),
                        CustomDropDown(
                          icon: Container(
                            margin: EdgeInsets.only(left: 16.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgBlueGrayDownArrow,
                              height: 16.h,
                              width: 18.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          iconSize: 16.h,
                          hintText: "Color of Vehicle",
                          hintStyle: CustomTextStyles.bodyMediumBluegray400,
                          items: dropdownItemList2,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.h,
                            vertical: 16.h,
                          ),
                        ),
                        SizedBox(height: 22.h),
                        Text(
                          "Vehicle Plate Number",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 6.h),
                        CustomTextFormField(
                          controller: plateNumberController,
                          hintText: "Enter your plate number",
                          textInputAction: TextInputAction.done,
                          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                        ),
                        SizedBox(height: 22.h),
                        Text(
                          "Vehicle Photo",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: double.maxFinite,
                          child: _buildFileuploadOne(
                            context,
                            clickToUpload: "Click to upload",
                            uploadSize: "PNG or JPG (max. 800x400px)",
                          ),
                        ),
                        SizedBox(height: 22.h),
                        Text(
                          "Driver's License",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: double.maxFinite,
                          child: _buildFileuploadOne(
                            context,
                            clickToUpload: "Click to upload",
                            uploadSize: "PNG or JPG (max. 800x400px)",
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          "Vehicle Inspector Report",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: _buildFileuploadOne(
                            context,
                            clickToUpload: "Click to upload",
                            uploadSize: "PNG or JPG (max. 800x400px)",
                          ),
                        ),
                        SizedBox(height: 22.h),
                        Text(
                          "Vehicle Insurance",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: double.maxFinite,
                          child: _buildFileuploadOne(
                            context,
                            clickToUpload: "Click to upload",
                            uploadSize: "PNG or JPG (max. 800x400px)",
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _buildColumnuploadacl(context)
                      ],
                    ),
                  ),
                  SizedBox(height: 78.h),
                  CustomElevatedButton(
                    text: "Submit",
                    buttonStyle: CustomButtonStyles.fillBlueGray,
                    buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                  ),
                  SizedBox(height: 4.h)
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context){
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgLeftArrow1,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 44.h,
          bottom: 22.h,
        ),
        onTap: () {onTapLeftArrow(context);},
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Vehicle Identification",
        margin: EdgeInsets.only(
          top: 45.h,
          bottom: 20.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildColumnuploadacl(BuildContext context){
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: appTheme.gray100,
        borderRadius: BorderRadiusStyle.roundedBorder4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Upload a clear and non-blurry image of your vehicle",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bodySmallLightGreen900.copyWith(height: 1.50,),
          ),
          SizedBox(height: 2.h),
          Text(
            "Ensure the correct image is being uploaded",
            style: CustomTextStyles.bodySmallLightGreen900,
          ),
          SizedBox(height: 2.h),
          Text(
            "This request will be reviewed in 3-5 mins",
            style: CustomTextStyles.bodySmallLightGreen900,
          )
        ],
      ),
    );
  }

  // Common Widget 
  Widget _buildFileuploadOne(
    BuildContext context, {
    required String clickToUpload,
    required String uploadSize,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(
          color: appTheme.blueGray10002,
          width: 1.h,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconButton(
            height: 40.h,
            width: 40.h,
            padding: EdgeInsets.all(10.h),
            decoration: IconButtonStyleHelper.outlineGrayTL20,
            child: CustomImageView(
              imagePath: ImageConstant.imgCloudUpload,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            clickToUpload,
            style: CustomTextStyles.titleSmallInterPrimary.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            uploadSize,
            style: CustomTextStyles.bodySmallInterGray600_1.copyWith(
              color: appTheme.gray600,
            ),
          )
        ],
      ),
    );
  }

  // Navigates back to the verification screen
  onTapLeftArrow(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.verificationScreen);
  }
}