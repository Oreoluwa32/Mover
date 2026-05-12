import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movr/presentation/check_mail_screen/notifier/check_mail_notifier.dart';

import '../../core/app_export.dart';
import '../../core/utils/app_toast.dart';
import '../../data/services/auth_api_service.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_pin_code_text_field.dart';
import '../../widgets/loading_dialog.dart';

class CheckMailScreen extends ConsumerStatefulWidget {
  final String email;

  const CheckMailScreen({super.key, required this.email});

  @override
  CheckMailScreenState createState() => CheckMailScreenState();
}

class CheckMailScreenState extends ConsumerState<CheckMailScreen> {
  static const int _resendCountdownSeconds = 30;

  Timer? _resendTimer;
  bool _isSubmitting = false;
  int _secondsUntilResend = _resendCountdownSeconds;

  TextEditingController? get _otpController =>
      ref.read(checkMailNotifier).otpController;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otpCode = _otpController?.text.trim() ?? '';
    if (_isSubmitting) {
      return;
    }
    if (otpCode.isEmpty) {
      AppToast.error("Please enter the verification code");
      return;
    }
    if (otpCode.length != 4) {
      AppToast.error("Please enter the 4-digit verification code");
      return;
    }

    final authApiService = AuthApiService();
    setState(() {
      _isSubmitting = true;
    });

    try {
      LoadingDialog.show(context, message: 'Verifying email...');
      final response = await authApiService.confirmEmailVerification(
        email: widget.email.trim(),
        code: otpCode,
      );
      if (!mounted) {
        return;
      }
      LoadingDialog.hide(context);
      AppToast.success(
        response['detail']?.toString() ?? "Email verified successfully",
      );
      Navigator.pushNamed(context, AppRoutes.emailVerifiedScreen);
    } catch (error) {
      if (mounted) {
        LoadingDialog.hide(context);
      }
      AppToast.error(authApiService.extractErrorMessage(error));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_secondsUntilResend > 0 || _isSubmitting) {
      return;
    }

    final authApiService = AuthApiService();
    setState(() {
      _isSubmitting = true;
    });

    try {
      AppToast.info("Sending a new code to your email...");
      final response = await authApiService.requestEmailVerification(
        email: widget.email.trim(),
      );
      _otpController?.clear();
      if (!mounted) {
        return;
      }
      AppToast.success(
        response['detail']?.toString() ??
            "A new verification code has been sent.",
      );
      _startResendCountdown();
    } catch (error) {
      AppToast.error(authApiService.extractErrorMessage(error));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() {
      _secondsUntilResend = _resendCountdownSeconds;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsUntilResend <= 1) {
        timer.cancel();
        setState(() {
          _secondsUntilResend = 0;
        });
        return;
      }
      setState(() {
        _secondsUntilResend -= 1;
      });
    });
  }

  String get _resendLabel {
    if (_secondsUntilResend > 0) {
      return "Resend code in ${_secondsUntilResend}s";
    }
    return "Click to resend";
  }

  @override
  Widget build(BuildContext context) {
    final otpController = ref.watch(checkMailNotifier).otpController;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 16.h,
                    top: 24.h,
                    right: 16.h,
                    bottom: 24.h,
                  ),
                  child: Column(
                    children: [
                      CustomIconButton(
                        height: 56.h,
                        width: 56.h,
                        padding: EdgeInsets.all(14.h),
                        decoration: IconButtonStyleHelper.outlineGray,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgMail,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        "Check your email",
                        style: theme.textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Enter the 4-digit verification code we sent to",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.email,
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.titleMediumGray600_1,
                      ),
                      SizedBox(height: 30.h),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.symmetric(horizontal: 30.h),
                        child: CustomPinCodeTextField(
                          context: context,
                          controller: otpController,
                          length: 4,
                          onChanged: (value) {
                            otpController?.text = value;
                          },
                          onCompleted: (value) {
                            if (value.trim().length == 4) {
                              _verifyOtp();
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "The code expires soon, so it’s best to verify right away.",
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.bodyMediumGray600,
                      ),
                      SizedBox(height: 28.h),
                      CustomElevatedButton(
                        text: _isSubmitting ? "Please wait..." : "Verify email",
                        buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                        onPressed: _isSubmitting ? null : _verifyOtp,
                      ),
                      SizedBox(height: 24.h),
                      GestureDetector(
                        onTap: (_secondsUntilResend == 0 && !_isSubmitting)
                            ? _resendOtp
                            : null,
                        child: Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.only(
                            left: 24.h,
                            right: 24.h,
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                "Didn't receive the email? ",
                                style: CustomTextStyles.bodyMediumGray600,
                              ),
                              Text(
                                _resendLabel,
                                style:
                                    (_secondsUntilResend == 0 && !_isSubmitting)
                                        ? CustomTextStyles.titleSmallPrimary_1
                                        : CustomTextStyles.bodyMediumGray600,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
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
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.signInScreen,
                            ),
                            child: Text(
                              "Back to log in",
                              style: CustomTextStyles.bodyMediumGray600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
