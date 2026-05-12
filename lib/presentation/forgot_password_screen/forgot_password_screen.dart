import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/app_toast.dart';
import '../../core/utils/validation_functions.dart';
import '../../data/services/auth_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/loading_dialog.dart';
import 'notifier/forgot_password_notifier.dart';

// Class must be immutable
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

// ignore for file, class must be immutable
class ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _prefilledInitialEmail = false;
  bool _isFormValid = false;
  TextEditingController? _emailController;

  // API call function to reset password
  Future<void> resetPassword(BuildContext context, String email) async {
    final authApiService = AuthApiService();

    if (email.isEmpty) {
      AppToast.error("Please enter your email address.");
      return;
    }

    LoadingDialog.show(context, message: 'Sending reset instructions...');
    try {
      final response = await authApiService.requestPasswordReset(email: email);
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      AppToast.success(
        response['detail']?.toString() ??
            "Reset instructions sent to your email.",
      );
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.passwordCheckMailScreen,
          arguments: {'email': email},
        );
      }
    } catch (e) {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      AppToast.error(authApiService.extractErrorMessage(e));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = ref.read(forgotPasswordNotifier).emailController;
    if (_emailController != controller) {
      _emailController?.removeListener(_updateFormValidity);
      _emailController = controller;
      _emailController?.addListener(_updateFormValidity);
    }
    if (_prefilledInitialEmail) {
      _updateFormValidity();
      return;
    }
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final email = args?['email']?.toString().trim() ?? '';
    if (email.isNotEmpty) {
      controller?.text = email;
    }
    _prefilledInitialEmail = true;
    _updateFormValidity();
  }

  @override
  void dispose() {
    _emailController?.removeListener(_updateFormValidity);
    super.dispose();
  }

  void _updateFormValidity() {
    final email = _emailController?.text ?? '';
    final isValid = isValidEmail(email, isRequired: true);
    if (_isFormValid != isValid && mounted) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordNotifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: 16.h,
                  top: 48.h,
                  right: 16.h,
                ),
                child: Column(
                  children: [
                    CustomIconButton(
                      height: 56.h,
                      width: 56.h,
                      padding: EdgeInsets.all(14.h),
                      decoration: IconButtonStyleHelper.outlineGray,
                      child: CustomImageView(
                          imagePath: ImageConstant.imgKey,
                          width: 20.h,
                          height: 20.h),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Forgot password?",
                      style: theme.textTheme.headlineSmall,
                    ),
                    Text(
                      "No worries, we'll send you reset instructions.",
                      style: theme.textTheme.bodyLarge,
                    ),
                    SizedBox(height: 24.h),
                    _buildColumnemailaddr(context),
                    SizedBox(height: 24.h),
                    CustomElevatedButton(
                      text: "Reset password",
                      buttonStyle: _isFormValid
                          ? CustomButtonStyles.fillPrimaryTL41
                          : CustomButtonStyles.fillBlueGray,
                      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                      onPressed: _isFormValid
                          ? () => resetPassword(
                                context,
                                forgotState.emailController?.text.trim() ?? '',
                              )
                          : null,
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgLeftArrow,
                          height: 20.h,
                          width: 20.h,
                        ),
                        SizedBox(width: 8.h),
                        GestureDetector(
                          onTap: () {
                            onTapBack(context);
                          },
                          child: Text(
                            "Back to log in",
                            style: CustomTextStyles.bodyMediumGray600,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 4.h)
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
  Widget _buildColumnemailaddr(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email Address*",
            style: CustomTextStyles.titleSmallGray600,
          ),
          SizedBox(height: 6.h),
          Consumer(builder: (context, ref, _) {
            return CustomTextFormField(
              controller: ref.watch(forgotPasswordNotifier).emailController,
              hintText: "Enter your email address",
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.emailAddress,
              contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
              validator: (value) {
                if (value == null || (!isValidEmail(value, isRequired: true))) {
                  return "Please enter a valid email";
                }
                return null;
              },
            );
          })
        ],
      ),
    );
  }

  // Navigates back to the sign in screen when the action is triggered
  onTapBack(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }

  // Navigates to the password check mail screen when the action is triggered
  onTapResetPassword(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.passwordCheckMailScreen);
  }
}
