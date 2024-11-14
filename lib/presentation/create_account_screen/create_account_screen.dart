import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_project/presentation/check_mail_screen/check_mail_screen.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/create_account_notifier.dart';

class CreateAccountScreen extends ConsumerStatefulWidget{
  const CreateAccountScreen({Key? key})
    : super(key: key,);

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}
// ignore for file, must be immutable
class CreateAccountScreenState extends ConsumerState<CreateAccountScreen>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to register user
Future<void> registerUser(BuildContext context, CreateAccountNotifier createAccountNotifier) async {
  final email = createAccountNotifier.state.emailController?.text ?? '';
  final password = createAccountNotifier.state.passwordController?.text ?? '';
  final url = Uri.parse('https://demosystem.pythonanywhere.com/register/'); // API endpoint

  // Check if the fields are not empty
  if (email.isEmpty || password.isEmpty) {
    Fluttertoast.showToast(msg: "Email and password cannot be empty");
    return;
  }

  // Prepare the request data
  try{
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    // Handle the response
    if(response.statusCode == 200 || response.statusCode == 201){
      // Registration successful, navigate to the nesxt screen
      Fluttertoast.showToast(msg: "Registration successful");
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => CheckMailScreen(email: email),
        ),
      );
    }
    else if (response.statusCode == 400 || response.statusCode == 409) {
    // Show error message if email already exists
      final errorData = json.decode(response.body);
      final errorMessage = errorData['error'] ?? 'This email is already registered. Please use a different email.';
      Fluttertoast.showToast(msg: errorMessage);
    }
    else{
      // Handle other error codes
      Fluttertoast.showToast(msg: "Registration failed. Please try again");
    }
  }
  catch (e) {
    // Handle network or JSON parsing errors
    Fluttertoast.showToast(msg: "An error occured. Please check your internet connection and try again.");
  }
}

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
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
                            SizedBox(width: 8.h),
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
      ),
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
          obscureText: true,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (value == null || (!isValidPassword(value, isRequired: true))) {
              return "Please enter a valid password";
            }
            return null;
          },
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
  Widget _buildGetstarted(BuildContext context){
    return CustomElevatedButton(
      text: "Get Started",
      buttonStyle: CustomButtonStyles.fillBlueGray,
      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
      onPressed: () {
        // Call the register function 
        if (_formKey.currentState?.validate() ?? false) {
              registerUser(context, ref.read(createAccountNotifier.notifier));
            }
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
    );
  }

  // Navigates to the check mail screen when the action is triggered and also pass the email
  void onTapGetStarted(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.checkMailScreen);
  }

  // Navigates to the sign in screen when the action is triggered
  onTapSignIn(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }
}