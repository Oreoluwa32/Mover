import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import '../../core/app_export.dart';
import '../../core/utils/app_toast.dart';
import '../../core/utils/validation_functions.dart';
import '../../data/services/account_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_phone_number.dart';
import '../../widgets/custom_text_form_field.dart';
import '../profile_screen/notifier/profile_screen_notifier.dart';
import 'notifier/personal_information_notifier.dart';

// ignore for file, class must be immutable
class PersonalInformationScreen extends ConsumerStatefulWidget {
  const PersonalInformationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  PersonalInformationScreenState createState() =>
      PersonalInformationScreenState();
}

// ignore for file, must be immutable
class PersonalInformationScreenState
    extends ConsumerState<PersonalInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addListeners();
      _loadProfile();
    });
  }

  void _addListeners() {
    final notifier = ref.read(personalInformationNotifier);
    notifier.firstNameController?.addListener(_updateFormValidation);
    notifier.lastNameController?.addListener(_updateFormValidation);
    notifier.emailController?.addListener(_updateFormValidation);
    notifier.phoneNumberController?.addListener(_updateFormValidation);
    notifier.facebookLinkController?.addListener(_updateFormValidation);
    notifier.instagramLinkController?.addListener(_updateFormValidation);
    notifier.linkedinLinkController?.addListener(_updateFormValidation);
  }

  void _updateFormValidation() {
    final notifier = ref.read(personalInformationNotifier);
    final firstName = notifier.firstNameController?.text.trim() ?? '';
    final lastName = notifier.lastNameController?.text.trim() ?? '';
    final email = notifier.emailController?.text.trim() ?? '';
    final phoneNumber = notifier.phoneNumberController?.text.trim() ?? '';

    // Check social media links if they are correct if not empty
    final facebookLink = notifier.facebookLinkController?.text.trim() ?? '';
    final instagramLink = notifier.instagramLinkController?.text.trim() ?? '';
    final linkedinLink = notifier.linkedinLinkController?.text.trim() ?? '';

    bool socialValid = true;
    if (facebookLink.isNotEmpty && !isValidFacebook(facebookLink))
      socialValid = false;
    if (instagramLink.isNotEmpty && !isValidInstagram(instagramLink))
      socialValid = false;
    if (linkedinLink.isNotEmpty && !isValidLinkedin(linkedinLink))
      socialValid = false;

    // Phone number should have more than just country code
    bool phoneValid = phoneNumber.isNotEmpty && phoneNumber.length > 4;

    setState(() {
      _isFormValid = firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          email.isNotEmpty &&
          phoneValid &&
          socialValid;
    });
  }

  @override
  void dispose() {
    // We should not dispose controllers here as they are managed by the notifier
    // but we can remove listeners if needed.
    // However, since it's autoDispose notifier, it should be fine.
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final accountApiService = AccountApiService();
    try {
      final profile = await accountApiService.getProfile();
      final notifier = ref.read(personalInformationNotifier);

      notifier.firstNameController?.text =
          profile['first_name']?.toString() ?? '';
      notifier.lastNameController?.text =
          profile['last_name']?.toString() ?? '';
      notifier.emailController?.text = profile['email']?.toString() ?? '';
      notifier.phoneNumberController?.text =
          profile['phone_number']?.toString().isNotEmpty == true
              ? profile['phone_number'].toString()
              : '+234';

      final linkedSocials =
          (profile['linked_socials'] as Map?)?.cast<String, dynamic>() ?? {};
      notifier.facebookLinkController?.text =
          linkedSocials['facebook']?.toString() ?? '';
      notifier.instagramLinkController?.text =
          linkedSocials['instagram']?.toString() ?? '';
      notifier.linkedinLinkController?.text =
          linkedSocials['linkedin']?.toString() ?? '';
      _updateFormValidation();
    } catch (_) {
      // Keep screen usable even if hydration fails.
    }
  }

  // Function to submit personal information to backend
  Future<void> submitPersonalInformation(BuildContext context,
      PersonalInformationNotifier personalInfoNotifier) async {
    final accountApiService = AccountApiService();
    if (_isSubmitting) {
      return;
    }

    final firstName =
        personalInfoNotifier.state.firstNameController?.text.trim() ?? '';
    final lastName =
        personalInfoNotifier.state.lastNameController?.text.trim() ?? '';
    final phoneNumber =
        personalInfoNotifier.state.phoneNumberController?.text.trim() ?? '';
    final facebookLink =
        personalInfoNotifier.state.facebookLinkController?.text.trim() ?? '';
    final instagramLink =
        personalInfoNotifier.state.instagramLinkController?.text.trim() ?? '';
    final linkedinLink =
        personalInfoNotifier.state.linkedinLinkController?.text.trim() ?? '';

    if (!_formKey.currentState!.validate()) {
      AppToast.error("Please correct the errors in the form.");
      return;
    }

    if (facebookLink.isNotEmpty && !isValidFacebook(facebookLink)) {
      AppToast.error("Enter a valid Facebook profile link.");
      return;
    }
    if (instagramLink.isNotEmpty && !isValidInstagram(instagramLink)) {
      AppToast.error("Enter a valid Instagram profile link.");
      return;
    }
    if (linkedinLink.isNotEmpty && !isValidLinkedin(linkedinLink)) {
      AppToast.error("Enter a valid LinkedIn profile link.");
      return;
    }

    try {
      setState(() {
        _isSubmitting = true;
      });
      final response = await accountApiService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        linkedSocials: {
          'facebook': facebookLink,
          'instagram': instagramLink,
          'linkedin': linkedinLink,
        },
      );

      final displayName = '$firstName $lastName'.trim().isNotEmpty
          ? '$firstName $lastName'.trim()
          : response['email']?.toString() ?? '';
      await const FlutterSecureStorage()
          .write(key: 'user_name', value: displayName);
      ref.invalidate(userNameProvider);

      final avatarUrl = response['avatar_url']?.toString();
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        await PrefUtils().setProfileImagePath(avatarUrl);
        ref.invalidate(profileImagePathProvider);
        ref.read(globalProfileImagePathProvider.notifier).updatePath(avatarUrl);
      }

      AppToast.success("Personal information updated successfully.");
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      AppToast.error(accountApiService.extractErrorMessage(e));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: 16.h,
                    top: 22.h,
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
                                style: CustomTextStyles.titleSmallGray600Medium
                                    .copyWith(
                                  height: 1.20,
                                ),
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
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 24.h),
              child: _buildSubmit(context),
            )
          ],
        ),
      ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 60.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeftBlack,
        margin: EdgeInsets.only(
          left: 16.h,
        ),
        onTap: () {
          onTapLeftArrow(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Personal Information",
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildFirstName(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller:
              ref.watch(personalInformationNotifier).firstNameController,
          hintText: "Enter your first name",
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (!isText(value)) {
              return "Please enter a valid first name";
            }
            return null;
          },
        );
      },
    );
  }

  // Section Widget
  Widget _buildLastName(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(personalInformationNotifier).lastNameController,
          hintText: "Enter your last name",
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (!isText(value)) {
              return "Please enter a valid last name";
            }
            return null;
          },
        );
      },
    );
  }

  // Section Widget
  Widget _buildEmail(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(personalInformationNotifier).emailController,
          hintText: "Enter your email",
          textInputType: TextInputType.emailAddress,
          readOnly: true,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (value == null || (!isValidEmail(value, isRequired: true))) {
              return "Please enter a valid email";
            }
            return null;
          },
        );
      },
    );
  }

  // Section Widget
  Widget _buildPhoneNumber(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Consumer(
        builder: (context, ref, _) {
          return CustomPhoneNumber(
            country: ref.watch(personalInformationNotifier).selectedCountry ??
                CountryPickerUtils.getCountryByPhoneCode('234'),
            controller:
                ref.watch(personalInformationNotifier).phoneNumberController,
            onTap: (Country value) {
              ref.watch(personalInformationNotifier).selectedCountry = value;
              ref
                  .read(personalInformationNotifier)
                  .phoneNumberController
                  ?.text = "+${value.phoneCode}";
              _updateFormValidation();
            },
          );
        },
      ),
    );
  }

  // Section Widget
  Widget _buildFacebookLink(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller:
              ref.watch(personalInformationNotifier).facebookLinkController,
          hintText: "Enter your facebook profile link",
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (value != null && value.isNotEmpty && !isValidFacebook(value)) {
              return "Please enter a valid facebook link";
            }
            return null;
          },
        );
      },
    );
  }

  // Section Widget
  Widget _buildInstagramLink(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller:
              ref.watch(personalInformationNotifier).instagramLinkController,
          hintText: "Enter your instagram profile link",
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (value != null && value.isNotEmpty && !isValidInstagram(value)) {
              return "Please enter a valid instagram link";
            }
            return null;
          },
        );
      },
    );
  }

  // Section Widget
  Widget _buildLinkedinLink(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller:
              ref.watch(personalInformationNotifier).linkedinLinkController,
          hintText: "Enter your linkedin profile link",
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (value != null && value.isNotEmpty && !isValidLinkedin(value)) {
              return "Please enter a valid linkedin link";
            }
            return null;
          },
        );
      },
    );
  }

  // Section Widget
  Widget _buildSubmit(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomElevatedButton(
          text: "Submit",
          buttonStyle: _isFormValid
              ? CustomButtonStyles.fillPrimaryTL41
              : CustomButtonStyles.fillBlueGray,
          buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
          isDisabled: !_isFormValid,
          isLoading: _isSubmitting,
          loadingText: "Saving information...",
          onPressed: () {
            if (_isFormValid) {
              submitPersonalInformation(
                  context, ref.read(personalInformationNotifier.notifier));
            }
          },
        );
      },
    );
  }

  // Navigates back to the home screen
  onTapLeftArrow(BuildContext context) {
    Navigator.pop(context);
  }
}
