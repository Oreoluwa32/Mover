import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_project/presentation/home_screen_dialog/home_screen_dialog.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import 'notifier/select_plan_notifier.dart';

class _PlanOption {
  final String imagePath;
  final List<String> features;
  final String name;

  const _PlanOption({
    required this.imagePath,
    required this.features,
    required this.name,
  });
}

class SelectPlanScreen extends ConsumerStatefulWidget{
  const SelectPlanScreen({Key? key})
    : super(key: key,);

  @override
  SelectPlanScreenState createState() => SelectPlanScreenState();
}

class SelectPlanScreenState extends ConsumerState<SelectPlanScreen> {

  final storage = FlutterSecureStorage();
  late final PageController _pageController;
  int _currentPlanIndex = 0;

  final List<_PlanOption> _plans = [
    _PlanOption(
      imagePath: 'assets/images/img_basic_plan.svg', // Placeholder image path
      name: 'Basic',
      features: [
        'Includes 10 trip searches per month',
        'Monetize 20 trips',
      ],
    ),
    _PlanOption(
      imagePath: 'assets/images/img_rover_plan.svg', // Placeholder image path
      name: 'Rover',
      features: [
        'Offers 35 trips searches per month',
        'Allows for 50 route additions to accomodate more diverse travel needs',
        'Advanced scheduling options for convenience',
      ],
    ),
    _PlanOption(
      imagePath: 'assets/images/img_courier_plan.svg', // Placeholder image path
      name: 'Courier',
      features: [
        'Unlimited trip searches for maximum flexibility',
        'Ability to manage multiple movers, streamlining logistics operations',
      ],
    ),
    _PlanOption(
      imagePath: 'assets/images/img_courier_plus.svg', // Placeholder image path
      name: 'Courier Plus',
      features: [
        'Unlimited trip searches for maximum flexibility',
        'Advanced scheduling options for convenience',
        'Advanced route editing capabilities',
        'Ability to manage multiple movers, streamlining logistics operations',
      ],
    ),
  ];

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> updateSubscriptionPlan(BuildContext context, String planName) async {
  final token = await getToken();
  if (token == null) {
    Fluttertoast.showToast(msg: "No token found. Please log in first.");
    return;
  }

  final url = Uri.parse('https://demosystem.pythonanywhere.com/update-subscription/');
  final requestBody = {
    "plan_name": planName,
  };

  try {
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final message = jsonDecode(response.body)['message'] ?? 'Subscription updated successfully';
      Fluttertoast.showToast(msg: message);
      Navigator.pushNamed(context, AppRoutes.homeScreenDialog);
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to update subscription plan';
      Fluttertoast.showToast(msg: error);
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "An error occurred. Please check your connection.");
  }
}

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.86);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 32.h),
                child: Column(
                  children: [
                    _buildColumnselectapl(context),
                    SizedBox(height: 24.h),
                    _buildHorizontalscroll(context),
                    SizedBox(height: 24.h),
                    _buildColumnfeatures(context),
                    SizedBox(height: 4.h)
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildColumnduration(context),
      );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context){
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgCancel,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 44.h,
          bottom: 22.h,
        ),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.homeScreenDialog);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Select a Plan",
        margin: EdgeInsets.only(
          top: 45.h,
          bottom: 20.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildColumnselectapl(BuildContext context){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      // padding: EdgeInsets.all(16.h),
      // decoration: BoxDecoration(
      //   border: Border.all(color: appTheme.deepPurpleA100, width: 1.3),
      //   borderRadius: BorderRadiusStyle.roundedBorder8,
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select a plan",
            style: CustomTextStyles.titleMediumBlack900,
          ),
          SizedBox(height: 12.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'By selecting a plan, you agree to our ',
                  style: CustomTextStyles.bodySmallBlack900,
                ),
                TextSpan(
                  text: "Terms of Service",
                  style: CustomTextStyles.bodySmallPrimary.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: ' and ',
                  style: CustomTextStyles.bodySmallBlack900,
                ),
                TextSpan(
                  text: "Privacy Policy",
                  style: CustomTextStyles.bodySmallPrimary.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.left,
          )
        ],
      ),
    );
  }

  // Section Widget 
  Widget _buildHorizontalscroll(BuildContext context){
    return SizedBox(
      height: 76.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _plans.length,
        onPageChanged: (index) {
          setState(() {
            _currentPlanIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final plan = _plans[index];
          final bool isSelected = index == _currentPlanIndex;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: appTheme.whiteA700,
                borderRadius: BorderRadiusStyle.roundedBorder16,
                border: Border.all(
                  color: isSelected ? appTheme.deepPurple400 : appTheme.gray400,
                  width: isSelected ? 2.h : 1.h,
                ),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.black900.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusStyle.roundedBorder16,
                child: CustomImageView(
                  imagePath: plan.imagePath,
                  height: 76.h,
                  width: 311.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Section Widget 
  Widget _buildColumnfeatures(BuildContext context){
    final plan = _plans[_currentPlanIndex];
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FEATURES",
            style: CustomTextStyles.titleSmallErrorContainerBold,
          ),
          SizedBox(height: 12.h),
          ...plan.features.map(
            (feature) => Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: _buildRowcheckmark(
                context,
                monetize20: feature,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Widget 
  Widget _buildColumnduration(BuildContext context){
    return Container(
      height: 116.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "1-week free trial. We'll send you a reminder 2 days before your trial ends.",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bodyMediumMulishGray600.copyWith(
              height: 1.43,
            ),
          ),
          SizedBox(height: 14.h),
          CustomElevatedButton(
            text: "Try for free",
            margin: EdgeInsets.only(bottom: 10.h),
            buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
            onPressed: () {
              updateSubscriptionPlan(context, _plans[_currentPlanIndex].name);
            },
          )
        ],
      ),
    );
  }

  // Common Widget 
  Widget _buildPlanThree(
    BuildContext context, {
      required String iconparksolid, 
      required String basicplanTwo, 
      required String priceThree,
      required String periodTwo,
    }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder8,
        border: Border.all(
          color: appTheme.gray400,
          width: 1.h,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: iconparksolid,
            height: 16.h,
            width: 16.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  basicplanTwo,
                  style: CustomTextStyles.titleSmallErrorContainer.copyWith(
                    color: theme.colorScheme.errorContainer,
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    priceThree,
                    style: CustomTextStyles.titleMediumGray8000118.copyWith(
                      color: appTheme.gray800,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    periodTwo,
                    style: CustomTextStyles.titleSmallGray600Medium.copyWith(
                      color: appTheme.gray600,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 4.h)
        ],
      ),
    );
  }

  // Common Widget 
  Widget _buildRowcheckmark(
    BuildContext context, {
      required String monetize20,
  }) {
    return Row(
      children: [
        Container(
          height: 18.h,
          width: 18.h,
          decoration: BoxDecoration(
            color: appTheme.deepPurple50,
            borderRadius: BorderRadiusStyle.roundedBorder8,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgPurpleCheckmark,
                height: 6.h,
                width: 8.h,
              )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Text(
              monetize20,
              style: CustomTextStyles.bodyMediumGray600.copyWith(
                color: appTheme.gray600,
              ),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }

  // Navigates to the home screen dialog
  onTapTryForFree(BuildContext context){
    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        content: HomeScreenDialog(),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
      )
    );
  }
}