import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_phone_number.dart';
import '../../widgets/custom_text_form_field.dart';

// ignore for file, class must be immutable
class PersonalInformationScreen extends StatelessWidget{
  PersonalInformationScreen({Key? key})
    : super(key: key,);

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Country selectedCountry = CountryPickerUtils.getCountryByPhoneCode('1');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController facebookLinkController = TextEditingController();
  TextEditingController instagramLinkController = TextEditingController();
  TextEditingController linkedinLinkController = TextEditingController();

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
                left: 16.h,
                top: 32.h,
                right: 16.h,
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
                            "Complete the necessary field to validate your identity",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.titleSmallGray600Medium.copyWith(height: 1.20,),
                          ),
                        ),
                        SizedBox(height: 26.h),
                        Text(
                          "First Name",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 4.h),
                        _buildFirstName(context),
                        SizedBox(height: 22.h),
                        Text(
                          "Last Name",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 4.h),
                        _buildLastName(context),
                        SizedBox(height: 22.h),
                        Text(
                          "Email Address*",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 6.h),
                        _buildEmail(context),
                        SizedBox(height: 22.h),
                        Text(
                          "Phone Number",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 6.h),
                        SizedBox(
                          width: double.maxFinite,
                          child: _buildPhoneNumber(context),
                        ),
                        SizedBox(height: 22.h),
                        Text(
                          "Facebook Profile Link",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 6.h),
                        _buildFacebookLink(context),
                        SizedBox(height: 22.h),
                        Text(
                          "Instagram Profile Link",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 4.h),
                        _buildInstagramLink(context),
                        SizedBox(height: 22.h),
                        Text(
                          "Linkedin Profile Link",
                          style: CustomTextStyles.titleSmallGray600,
                        ),
                        SizedBox(height: 6.h),
                        _buildLinkedinLink(context)
                      ],
                    ),
                  ),
                  SizedBox(height: 78.h),
                  _buildSubmit(context),
                  SizedBox(height: 4.h)
                ],
              ),
            ),
          ),
        ),
      ),
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
        text: "Personal Information",
        margin: EdgeInsets.only(
          top: 45.h,
          bottom: 20.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildFirstName(BuildContext context){
    return CustomTextFormField(
      controller: firstNameController,
      hintText: "Enter your first name",
      contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
    );
  }

  // Section Widget
  Widget _buildLastName(BuildContext context){
    return CustomTextFormField(
      controller: lastNameController,
      hintText: "Enter your last name",
      contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
    );
  }

  // Section Widget
  Widget _buildEmail(BuildContext context){
    return CustomTextFormField(
      controller: emailController,
      hintText: "Enter your email address",
      textInputType: TextInputType.emailAddress,
      contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
    );
  }

  // Section Widget
  Widget _buildPhoneNumber(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: CustomPhoneNumber(
        country: selectedCountry, 
        onTap: (Country value){
          selectedCountry = value;
        }, 
        controller: phoneNumberController),
    );
  }

  // Section Widget
  Widget _buildFacebookLink(BuildContext context){
    return CustomTextFormField(
      controller: facebookLinkController,
      hintText: "Enter your facebook profile link",
      contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
    );
  }

  // Section Widget
  Widget _buildInstagramLink(BuildContext context){
    return CustomTextFormField(
      controller: instagramLinkController,
      hintText: "Enter your instagram profile link",
      contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
    );
  }

  // Section Widget
  Widget _buildLinkedinLink(BuildContext context){
    return CustomTextFormField(
      controller: linkedinLinkController,
      hintText: "Enter your linkedin profile link",
      textInputAction: TextInputAction.done,
      contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
    );
  }

  // Section Widget
  Widget _buildSubmit(BuildContext context){
    return CustomElevatedButton(
      text: "Submit",
      buttonStyle: CustomButtonStyles.fillBlueGray,
      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
    );
  }

  // Navigates back to the home screen
  onTapLeftArrow(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.verificationScreen);
  }
}