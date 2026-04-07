import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movr/domain/googleauth/google_auth_helper.dart';
import '../../services/device_memory_service.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../data/services/account_api_service.dart';
import '../../data/services/auth_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/loading_dialog.dart';
import 'notifier/create_account_notifier.dart';
import '../profile_screen/notifier/profile_screen_notifier.dart';

class CreateAccountScreen extends ConsumerStatefulWidget{
  const CreateAccountScreen({Key? key})
    : super(key: key,);

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}
// ignore for file, must be immutable
class CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Function to register user
Future<void> registerUser(
  BuildContext context,
  CreateAccountNotifier createAccountNotifier,
) async {
  final email = createAccountNotifier.state.emailController?.text ?? '';
  final password = createAccountNotifier.state.passwordController?.text ?? '';
  final authApiService = AuthApiService();
  final accountApiService = AccountApiService();

  // Check if the fields are not empty
  if (email.isEmpty || password.isEmpty) {
    Fluttertoast.showToast(msg: "Email and password are required");
    return;
  }

  // Show loading dialog
  LoadingDialog.show(context, message: 'Creating account...');

  // Prepare the request data
  try{
    final response = await authApiService.register(
      email: email,
      password: password,
    );

    await authApiService.persistSession(response);
    await accountApiService.hydrateSessionFromMe();

    // Hide loading dialog
    if (context.mounted) {
      LoadingDialog.hide(context);
    }

    final deviceMemory = DeviceMemoryService();
    await deviceMemory.rememberDevice(userEmail: email);

    Fluttertoast.showToast(msg: "Registration successful");
    if (context.mounted) {
      Navigator.pushNamed(context, AppRoutes.selectPlanScreen);
    }
  }
  catch (e) {
    if (context.mounted) {
      LoadingDialog.hide(context);
    }
    final errorMessage = authApiService.extractErrorMessage(e);
    Fluttertoast.showToast(msg: errorMessage);
    if (errorMessage.toLowerCase().contains('already')) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.signInScreen,
          (route) => route.isFirst,
        );
      }
    }
  }
}

  void _validateForm(CreateAccountNotifier notifier) {
    final email = notifier.state.emailController?.text ?? '';
    final password = notifier.state.passwordController?.text ?? '';
    
    final isValid = isValidEmail(email, isRequired: true) && 
                    isValidPassword(password, isRequired: true);
    
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
        final notifier = ref.watch(createAccountNotifier);
        // Listen to changes in the text fields
        notifier.emailController?.addListener(() => _validateForm(ref.read(createAccountNotifier.notifier)));
        notifier.passwordController?.addListener(() => _validateForm(ref.read(createAccountNotifier.notifier)));

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
                          CustomImageView(
                            imagePath: ImageConstant.imgLogoWithoutText,
                            height: 32.h,
                            width: 50.h,
                            alignment: Alignment.centerLeft,
                          ),
                          SizedBox(height: 20.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Let's get you started",
                              style: theme.textTheme.headlineSmall,
                            ),
                          ),
                          Text(
                            "Unlock the power of interconnected mobility",
                            style: CustomTextStyles.titleMediumGray600,
                          ),
                          SizedBox(height: 26.h),
                          _buildColumnemailaddr(context),
                          SizedBox(height: 22.h),
                          _buildColumnpassword(context),
                          SizedBox(height: 22.h),
                          _buildGetstarted(context),
                          SizedBox(height: 16.h),
                          _buildSignupwith(context),
                          SizedBox(height: 32.h),
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(
                              left: 58.h,
                              right: 62.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: CustomTextStyles.bodyMediumGray600,
                                ),
                                SizedBox(width: 4.h),
                                GestureDetector(
                                  onTap: () {onTapSignIn(context);},
                                  child: Text(
                                    "Sign in",
                                    style: CustomTextStyles.titleSmallPrimary_1,
                                  ),
                                )
                              ],
                            ),
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
      },
    );
  }

  // Section Widget 
  Widget _buildEmail(BuildContext context){
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(createAccountNotifier).emailController,
          hintText: "Enter your email address",
          textInputType: TextInputType.emailAddress,
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
          controller: ref.watch(createAccountNotifier).passwordController,
          hintText: "Create a password",
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
          obscureText: _obscurePassword,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (value == null || (!isValidPassword(value, isRequired: true))) {
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
      },
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
            "Must be at least 8 characters with at least a cap letter and a special character.",
            style: CustomTextStyles.bodyMediumGray600,
          )
        ],
      ),
    );
  }

  // Sectiom Widget 
  Widget _buildGetstarted(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomElevatedButton(
          text: "Get Started",
          buttonStyle: _isFormValid
              ? CustomButtonStyles.fillPrimaryTL41 // Use primary color when valid
              : CustomButtonStyles.fillBlueGray, // Default color when not valid
          buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
          onPressed: _isFormValid
              ? () {
                  if (_formKey.currentState?.validate() ?? false) {
                    registerUser(
                      context,
                      ref.read(createAccountNotifier.notifier),
                    );
                  }
                }
              : null, // Disable button if not valid
        );
      },
    );
  }

  // Sectiomn Widget 
  Widget _buildSignupwith(BuildContext context){
    return CustomOutlinedButton(
      text: "Sign up with Google",
      leftIcon: Container(
        margin: EdgeInsets.only(right: 12.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgGoogleLogo,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonTextStyle: CustomTextStyles.titleSmallBluegray800,
      onPresssed: () {
        googleSignIn(context);
      },
    );
  }

  googleSignIn(BuildContext context) async {
    LoadingDialog.show(context, message: 'Signing up with Google...');
    
    await GoogleAuthHelper().googleSignInProcess().then((googleUser) async {
      if (googleUser != null) {
        // Authenticate with backend
        final authResponse = await GoogleAuthHelper().authenticateWithBackend(googleUser);
        
        if (context.mounted) {
          LoadingDialog.hide(context);
        }
        
        if (authResponse != null) {
          onSuccessGoogleAuthResponse(googleUser, context, authResponse);
        } else {
          onErrorGoogleAuthResponse(context);
        }
      } else {
        if (context.mounted) {
          LoadingDialog.hide(context);
        }
        onErrorGoogleAuthResponse(context);
      }
    }).catchError((onError) {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      onErrorGoogleAuthResponse(context);
    });
  }

  // Navigates to the check mail screen when the action is triggered and also pass the email
  void onTapGetStarted(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.checkMailScreen);
  }

  // Navigates to the select plan screen when the action is triggered
  onSuccessGoogleAuthResponse(GoogleSignInAccount googleUser, BuildContext context, Map<String, dynamic> authResponse) async {
    // Store tokens securely
    final storage = FlutterSecureStorage();
    final token = authResponse['token']?['key'] ?? authResponse['access_token'];
    if (token != null) {
      await storage.write(key: 'auth_token', value: token);
    }
    await storage.write(key: 'user_email', value: googleUser.email);
    if (googleUser.displayName != null && googleUser.displayName!.isNotEmpty) {
      await storage.write(key: 'user_name', value: googleUser.displayName);
    }
    
    // Sync profile image from Google if available
    if (googleUser.photoUrl != null && googleUser.photoUrl!.isNotEmpty) {
      await PrefUtils().setProfileImagePath(googleUser.photoUrl!);
      
      // Update the global provider for immediate UI update
      try {
        ref.read(globalProfileImagePathProvider.notifier).updatePath(googleUser.photoUrl);
      } catch (e) {
        debugPrint('Error updating globalProfileImagePathProvider: $e');
      }
    }
    
    // Remember device
    final deviceMemory = DeviceMemoryService();
    await deviceMemory.rememberDevice(userEmail: googleUser.email);
    
    // Mark onboarding as completed
    await PrefUtils().setOnboardingCompleted(true);
    
    Fluttertoast.showToast(msg: "Sign-up successful");
    Navigator.pushNamed(context, AppRoutes.selectPlanScreen);
  }

  // Displays a snackbar with a custom message
  // The [context] parameter should be the context of the widget that is calling this function
  onErrorGoogleAuthResponse(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error signing you in with Google"))
    );
  }

  onTapSignIn(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }
}
