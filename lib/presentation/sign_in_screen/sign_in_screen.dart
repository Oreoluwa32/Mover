import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../data/services/auth_api_service.dart';
import '../../data/services/account_api_service.dart';
import '../../domain/googleauth/google_auth_helper.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/loading_dialog.dart';
import '../../services/device_memory_service.dart';
import 'notifier/sign_in_notifier.dart';

// Secure storage instance
final storage = FlutterSecureStorage();

bool _obscurePassword = true;

// Function to handle user sign-in
Future<void> signInUser(BuildContext context, WidgetRef ref) async {
  final notifier = ref.read(signInNotifier.notifier);
  final email = notifier.state.emailController?.text ?? '';
  final password = notifier.state.passwordController?.text ?? '';
  final authApiService = AuthApiService();
  final accountApiService = AccountApiService();

  if (email.isEmpty || password.isEmpty) {
    Fluttertoast.showToast(msg: "Email and password cannot be empty.");
    return;
  }

  // Show loading dialog
  LoadingDialog.show(context, message: 'Signing in...');

  try {
    final responseData = await authApiService.login(
      email: email,
      password: password,
    );

    await authApiService.persistSession(responseData);
    await accountApiService.hydrateSessionFromMe();

    final user = (responseData['user'] as Map?)?.cast<String, dynamic>() ?? {};

      // Remember device
      final deviceMemory = DeviceMemoryService();
      await deviceMemory.rememberDevice(userEmail: email);

    if (context.mounted) {
      LoadingDialog.hide(context);
    }

    Fluttertoast.showToast(msg: "Sign-in successful");

    final userSubscriptionPlan =
        user['subscription_plan'] ?? user['plan_name'] ?? user['plan'];
    final hasSubscriptionPlan =
        userSubscriptionPlan != null && userSubscriptionPlan.toString().isNotEmpty;

    if (context.mounted) {
      if (hasSubscriptionPlan) {
        Navigator.pushNamed(context, AppRoutes.homeOneScreen);
      } else {
        Navigator.pushNamed(context, AppRoutes.selectPlanScreen);
      }
    }
  } catch (e) {
    if (context.mounted) {
      LoadingDialog.hide(context);
    }
    if (authApiService.isEmailVerificationRequiredError(e)) {
      Fluttertoast.showToast(
        msg: authApiService.extractErrorMessage(e),
      );
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.checkMailScreen,
          arguments: {
            'email': authApiService.extractVerificationEmail(e) ?? email.trim(),
          },
        );
      }
      return;
    }
    Fluttertoast.showToast(
      msg: authApiService.extractErrorMessage(e),
    );
  }
}

// Class must be immutable
class SignInScreen extends ConsumerStatefulWidget{
  const SignInScreen({Key? key})
    : super(key: key,);

  @override SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends ConsumerState<SignInScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  void _validateForm(SignInNotifier notifier) {
    final email = notifier.state.emailController?.text ?? '';
    final password = notifier.state.passwordController?.text ?? '';
    final isValid = isValidEmail(email, isRequired: true) && isValidPassword(password, isRequired: true);
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.watch(signInNotifier);
        // Listen to changes in the text fields
        notifier.emailController?.addListener(() => _validateForm(ref.read(signInNotifier.notifier)));
        notifier.passwordController?.addListener(() => _validateForm(ref.read(signInNotifier.notifier)));

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgLogoWithoutText,
                            height: 32.h,
                            width: 50.h,
                            alignment: Alignment.centerLeft,
                          ),
                          SizedBox(height: 16.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Welcome back",
                              style: theme.textTheme.headlineSmall,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Welcome back! Please enter your details.",
                              style: CustomTextStyles.titleMediumGray600,
                            ),
                          ),
                          SizedBox(height: 26.h),
                          _buildColumnemailaddr(context),
                          SizedBox(height: 22.h),
                          _buildColumnpassword(context),
                          SizedBox(height: 22.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {onTapForgotPassword(context);},
                              child: Text(
                                "Forgot password",
                                style: CustomTextStyles.titleSmallPrimary,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          _buildSignin(context),
                          SizedBox(height: 16.h),
                          _buildSigninwith(context),
                          SizedBox(height: 30.h),
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(
                              left: 64.h,
                              right: 68.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: CustomTextStyles.bodyMediumGray600,
                                ),
                                SizedBox(width: 3.h),
                                GestureDetector(
                                  onTap: () {onTapSignUp(context);},
                                  child: Text(
                                    "Sign up",
                                    style: CustomTextStyles.titleSmallPrimary_1,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 142.h)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
      },
    );
  }

  // Section Widget 
  Widget _buildEmail(BuildContext context){
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(signInNotifier).emailController,
          hintText: "Enter your email address",
          textInputType: TextInputType.emailAddress,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if(value == null || (!isValidEmail(value, isRequired: true))) {
              return "Please enter a valid email";
            }
            return null;
          },
        );
      },
    );
  }

  // Section Widget 
  Widget _buildColumnemailaddr(BuildContext context){
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
          _buildEmail(context)
        ],
      ),
    );
  }

  // Section Widget 
  Widget _buildPassword(BuildContext context){
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(signInNotifier).passwordController,
          hintText: "Enter your password",
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
          obscureText: _obscurePassword,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if(value == null || (!isValidPassword(value, isRequired: true))) {
              return "Please enter a valid password";
            }
            return null;
          },
          // Add suffix icon for show/hide password
          suffix: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        );
      }
    );
  }

  // Section Widget 
  Widget _buildColumnpassword(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password*",
            style: CustomTextStyles.titleSmallGray600,
          ),
          SizedBox(height: 6.h),
          _buildPassword(context),
          SizedBox(height: 6.h),
          Text(
            "Must be at least 8 characters.",
            style: CustomTextStyles.bodyMediumGray600,
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildSignin(BuildContext context){
    return Consumer(
      builder: (context, ref, _){
        return CustomElevatedButton(
          text: "Sign in",
          buttonStyle: _isFormValid ? CustomButtonStyles.fillPrimaryTL41 : CustomButtonStyles.fillBlueGray,
          buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
          onPressed: () {
            if(_formKey.currentState?.validate() ?? false) {
              signInUser(context, ref);
            }
          },
        );
      }
    );
  }

  // Section Widget
  Widget _buildSigninwith(BuildContext context){
    return CustomOutlinedButton(
      text: "Sign in with Google",
      leftIcon: Container(
        margin: EdgeInsets.only(right: 12.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgGoogleLogo,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
      onPresssed: () {
        onTapSigninwithGoogle(context);
      },
    );
  }

  // Navigates to the forgot password screen when the action is triggered
  onTapForgotPassword(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen);
  }

  // Navigates to the create account screen when the action is trigered
  onTapSignUp(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.createAccountScreen);
  }

  // Navigates to the check mail screen when the action is triggered
  onTapSignIn(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.selectPlanScreen);
  }

  onTapSigninwithGoogle(BuildContext context) async {
    LoadingDialog.show(context, message: 'Signing in with Google...');
    
    await GoogleAuthHelper().googleSignInProcess().then((googleUser) async {
      if(googleUser != null) {
        // Authenticate with backend
        final authResponse = await GoogleAuthHelper().authenticateWithBackend(googleUser);
        
        if (context.mounted) {
          LoadingDialog.hide(context);
        }
        
        if (authResponse != null) {
          // Store tokens securely
          final token = authResponse['token']?['key'] ?? authResponse['access_token'];
          if (token != null) {
            await storage.write(key: 'auth_token', value: token);
          }
          
          // Remember device
          final deviceMemory = DeviceMemoryService();
          await deviceMemory.rememberDevice(userEmail: googleUser.email);
          
          // Mark onboarding as completed
          await PrefUtils().setOnboardingCompleted(true);
          
          Fluttertoast.showToast(msg: "Sign-in successful");
          
          // Check if user has a subscription plan
          final userSubscriptionPlan = authResponse['user']?['subscription_plan'] ?? authResponse['user']?['plan'];
          final hasSubscriptionPlan = userSubscriptionPlan != null && userSubscriptionPlan.toString().isNotEmpty;
          
          // Navigate based on subscription plan status
          if (context.mounted) {
            if (hasSubscriptionPlan) {
              Navigator.pushNamed(context, AppRoutes.homeOneScreen);
            } else {
              Navigator.pushNamed(context, AppRoutes.selectPlanScreen);
            }
          }
        } else {
          Fluttertoast.showToast(msg: "Failed to sign in. Please try again.");
        }
      } else {
        if (context.mounted) {
          LoadingDialog.hide(context);
        }
        Fluttertoast.showToast(msg: 'Sign-in cancelled');
      }
    }).catchError((onError) {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      Fluttertoast.showToast(msg: 'Error: ${onError.toString()}');
    });
  }
}
