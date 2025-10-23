import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
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
Future<void> signInUser(BuildContext context, SignInNotifier signInNotifier) async {
  final email = signInNotifier.state.emailController?.text ?? '';
  final password = signInNotifier.state.passwordController?.text ?? '';
  final url = Uri.parse('https://movr-api.onrender.com/api/v1/auth/login'); // Login endpoint

  if (email.isEmpty || password.isEmpty) {
    Fluttertoast.showToast(msg: "Email and password cannot be empty.");
    return;
  }

  // Show loading dialog
  LoadingDialog.show(context, message: 'Signing in...');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'email': email, 'password': password}),
    );

    // Hide loading dialog
    if (context.mounted) {
      LoadingDialog.hide(context);
    }

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String accessToken = responseData['access_token'];
      String refreshToken = responseData['refresh_token'];
      
      // Store tokens securely
      await storage.write(key: 'auth_token', value: accessToken);
      await storage.write(key: 'refresh_token', value: refreshToken);
      
      // Remember device
      final deviceMemory = DeviceMemoryService();
      await deviceMemory.rememberDevice(userEmail: email);
      
      Fluttertoast.showToast(msg: "Sign-in successful");
      // Navigate to the next screen
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoutes.selectPlanScreen);
      }
    } 
    else if (response.statusCode == 403) {
      // Check if the error is email not verified
      try {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['detail'] ?? 'Sign-in failed. Please try again.';
        
        if (errorMessage == 'email_not_verified') {
          // Navigate to check mail screen with email
          Fluttertoast.showToast(msg: "Email not verified. Please check your email for the OTP.");
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.checkMailScreen,
              (route) => route.isFirst,
              arguments: {'email': email},
            );
          }
        } else {
          Fluttertoast.showToast(msg: errorMessage);
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Sign-in failed. Please try again.');
      }
    }
    else {
      try {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['detail'] ?? 'Sign-in failed. Please try again.';
        Fluttertoast.showToast(msg: errorMessage);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Sign-in failed. Please try again.');
      }
    }
  } catch (e) {
    // Hide loading dialog
    if (context.mounted) {
      LoadingDialog.hide(context);
    }
    Fluttertoast.showToast(msg: "An error occurred. Please check your connection.");
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
              signInUser(context, ref.read(signInNotifier.notifier));
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
          await storage.write(key: 'auth_token', value: authResponse['access_token']);
          await storage.write(key: 'refresh_token', value: authResponse['refresh_token']);
          
          // Remember device
          final deviceMemory = DeviceMemoryService();
          await deviceMemory.rememberDevice(userEmail: googleUser.email);
          
          Fluttertoast.showToast(msg: "Sign-in successful");
          
          if (context.mounted) {
            Navigator.pushNamed(context, AppRoutes.selectPlanScreen);
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