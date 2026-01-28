import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/identification_notifier.dart';

class IdentificationScreen extends ConsumerStatefulWidget {
  const IdentificationScreen({Key? key}) : super(key: key);

  @override
  IdentificationScreenState createState() => IdentificationScreenState();
}

class IdentificationScreenState extends ConsumerState<IdentificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addListeners();
    });
  }

  void _addListeners() {
    final notifier = ref.read(identificationNotifier);
    notifier.ninController?.addListener(_updateFormValidation);
    notifier.bvnController?.addListener(_updateFormValidation);
  }

  void _updateFormValidation() {
    final notifier = ref.read(identificationNotifier);
    final nin = notifier.ninController?.text.trim() ?? '';
    final bvn = notifier.bvnController?.text.trim() ?? '';

    setState(() {
      _isFormValid = nin.length == 11 && bvn.length == 11;
    });
  }

  Future<String?> getToken() async {
    final storage = const FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }

  Future<void> submitIdentification(BuildContext context) async {
    final token = await getToken();
    if (token == null) {
      Fluttertoast.showToast(msg: "No token found. Please log in first.");
      return;
    }

    final notifier = ref.read(identificationNotifier);
    final nin = notifier.ninController?.text.trim() ?? '';
    final bvn = notifier.bvnController?.text.trim() ?? '';

    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please correct the errors in the form.");
      return;
    }

    final url = Uri.parse('https://demosystem.pythonanywhere.com/update-kyc/');
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json"
        },
        body: json.encode({
          "nin": nin,
          "bvn": bvn,
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Identification updated successfully.",
          backgroundColor: appTheme.green50,
          textColor: Colors.white,
        );
        Navigator.pushNamed(context, AppRoutes.verificationScreen);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? "Failed to update identification.";
        Fluttertoast.showToast(msg: errorMessage);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
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
                    right: 16.h,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            SizedBox(
                              width: 292.h,
                              child: Text(
                                "Provide your identification details to complete KYC",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyles.titleSmallGray600Medium.copyWith(height: 1.20),
                              ),
                            ),
                            SizedBox(height: 26.h),
                            Text(
                              "National Identity Number (NIN)",
                              style: CustomTextStyles.titleSmallGray600,
                            ),
                            SizedBox(height: 4.h),
                            _buildNIN(context),
                            SizedBox(height: 22.h),
                            Text(
                              "Bank Verification Number (BVN)",
                              style: CustomTextStyles.titleSmallGray600,
                            ),
                            SizedBox(height: 4.h),
                            _buildBVN(context),
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
        text: "Identification",
      ),
      styleType: Style.bgOutline,
    );
  }

  Widget _buildNIN(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(identificationNotifier).ninController,
          hintText: "Enter your NIN",
          textInputType: TextInputType.number,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (value == null || value.length != 11) {
              return "Please enter a valid 11-digit NIN";
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildBVN(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(identificationNotifier).bvnController,
          hintText: "Enter your BVN",
          textInputType: TextInputType.number,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (value == null || value.length != 11) {
              return "Please enter a valid 11-digit BVN";
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildSubmit(BuildContext context) {
    return CustomElevatedButton(
      text: "Submit",
      buttonStyle: _isFormValid ? CustomButtonStyles.fillPrimaryTL41 : CustomButtonStyles.fillGray,
      onPressed: _isFormValid
          ? () {
              submitIdentification(context);
            }
          : null,
    );
  }

  void onTapLeftArrow(BuildContext context) {
    Navigator.pop(context);
  }
}
