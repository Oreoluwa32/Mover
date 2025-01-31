import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../activity_in_progress_page/activity_in_progress_page.dart';
import '../home_one_screen/home_one_initial_page.dart';
import '../my_route_page/my_route_page.dart';
import 'notifier/profile_screen_notifier.dart';

// Secure storage instance
final storage = FlutterSecureStorage();

// Function to handle to log out the user 
Future<void> logoutUser(BuildContext context) async {
  await storage.deleteAll();
  Navigator.pushNamed(context, AppRoutes.signInScreen);
}

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key})
      : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

// ignore for file, class must be immutable
class ProfileScreenState extends ConsumerState<ProfileScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 28.h
              ), 
              _buildAccount(context)
            ],
          ),
        ),
        bottomNavigationBar: Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          child: _buildBottombar(context),
        ),
      ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Profile",
        margin: EdgeInsets.only(
          top: 46.h,
          bottom: 19.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildAccount(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileDetails(context),
                SizedBox(height: 30.h,),
                Text(
                  "Account",
                  style: CustomTextStyles.bodySmallBluegray400,
                ),
                SizedBox(height: 4.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgBlackWallet,
                    title: "Wallet",
                  ),
                ),
                SizedBox(height: 8.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgDocument,
                    title: "Document",
                  ),
                ),
                SizedBox(height: 8.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgNotification,
                    title: "Notifications",
                  ),
                ),
                SizedBox(height: 8.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgChat,
                    title: "Chats",
                  ),
                ),
                SizedBox(height: 16.h,),
                Text(
                  "Privacy",
                  style: CustomTextStyles.bodySmallBluegray400,
                ),
                SizedBox(height: 10.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgSecurityLock,
                    title: "Security",
                  ),
                ),
                SizedBox(height: 8.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgChatSupport,
                    title: "Chat Support",
                  ),
                ),
                SizedBox(height: 8.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgReferParty,
                    title: "Refer Friends",
                  ),
                ),
                SizedBox(height: 8.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgRate,
                    title: "Rate Us",
                  ),
                ),
                SizedBox(height: 8.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgPolicy,
                    title: "Policy",
                  ),
                ),
                SizedBox(height: 8.h,),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgLanguage,
                    title: "Language (English)",
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20.h,),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  logoutUser(context);
                },
                child: Row(
                  children: [
                    Text(
                    "Log out",
                    style: CustomTextStyles.bodySmallRedA700,
                  ),
                  SizedBox(width: 4.h,),
                  CustomImageView(
                    imagePath: ImageConstant.imgLogout,
                    width: 15.h,
                    height: 15.h,
                  ),
                  ],
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildProfileDetails(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgProfile,
                  width: 50.h,
                  height: 50.h,
                  radius: BorderRadius.circular(24.h),
                ),
                SizedBox(width: 16.h,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Doe",
                        style: CustomTextStyles.titleMediumGray80001Medium,
                      ),
                      SizedBox(height: 2.h,),
                      Text(
                        "Profile Information",
                        style: CustomTextStyles.bodySmall110,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgChevronRightBlack,
            width: 16.h,
            height: 16.h,
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildBottombar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          Navigator.pushNamed(navigatorKey.currentContext!, getCurrentRoute(type));
        },
      ),
    );
  }

  // Common Widget
  Widget _buildCard(BuildContext context, {
    required String icon,
    required String title
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.h
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: icon,
            height: 18.h,
            width: 18.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: Text(
              title,
              style: CustomTextStyles.labelLargeMedium.copyWith(
                color: appTheme.gray80001
              ),
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgChevronRightBlack,
            height: 16.h,
            width: 16.h,
          )
        ],
      ),
    );
  }

  // Handling route based on the bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homeOneInitialPage;
      case BottomBarEnum.Route:
        return AppRoutes.myRoutePage;
      case BottomBarEnum.Activity:
        return AppRoutes.activityInProgressPage;
      case BottomBarEnum.Profile:
        return AppRoutes.profileScreen;
      default:
        return "/";
    }
  }
}