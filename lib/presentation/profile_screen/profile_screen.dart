import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/permission_manager.dart';
import '../../data/services/account_api_service.dart';
import '../../services/device_memory_service.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/user_avatar.dart';
import '../wallet/notifier/wallet_notifier.dart';
import 'notifier/profile_screen_notifier.dart';

// Function to handle to log out the user
Future<void> logoutUser(BuildContext context) async {
  try {
    await AccountApiService().clearSession();
    await DeviceMemoryService().forgetDevice();
    if (context.mounted) {
      NavigatorService.pushNamedAndRemoveUntil(
        AppRoutes.signInScreen,
      );
    }
  } catch (e) {
    await AccountApiService().clearSession();
    await DeviceMemoryService().forgetDevice();
    if (context.mounted) {
      NavigatorService.pushNamedAndRemoveUntil(
        AppRoutes.signInScreen,
      );
    }
  }
}

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

// ignore for file, class must be immutable
class ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AccountApiService().hydrateSessionFromMe();
      ref.invalidate(userNameProvider);
      ref.invalidate(profileImagePathProvider);
      final imagePath = await PrefUtils().getProfileImagePath();
      ref.read(globalProfileImagePathProvider.notifier).updatePath(imagePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [SizedBox(height: 28.h), _buildAccount(context)],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   width: double.maxFinite,
      //   margin: EdgeInsets.symmetric(horizontal: 16.h),
      //   child: _buildBottombar(context),
      // ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 60.h,
      leadingWidth: 40.h,
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Profile",
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildAccount(BuildContext context) {
    final walletBalance = ref.watch(walletBalanceProvider);
    final walletTitle = walletBalance.when(
      data: (balance) => "Wallet: ₦${balance.toInt()}",
      loading: () => "Wallet: ...",
      error: (_, __) => "Wallet",
    );

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
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "Account",
                  style: CustomTextStyles.bodySmallBluegray400,
                ),
                SizedBox(
                  height: 4.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(context,
                      icon: ImageConstant.imgBlackWallet,
                      title: walletTitle, onTapCard: () {
                    onTapWallet(context);
                  }),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgDocument,
                    title: "Document",
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgNotification,
                    title: "Notifications",
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgChat,
                    title: "Chats",
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  "Privacy",
                  style: CustomTextStyles.bodySmallBluegray400,
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgSecurityLock,
                    title: "Security",
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgChatSupport,
                    title: "Chat Support",
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(context,
                      icon: ImageConstant.imgReferParty,
                      title: "Refer Friends", onTapCard: () {
                    onTapReferFriends(context);
                  }),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgRate,
                    title: "Rate Us",
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgPolicy,
                    title: "Policy",
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(
                    context,
                    icon: ImageConstant.imgLanguage,
                    title: "Language (English)",
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  "Appearance",
                  style: CustomTextStyles.bodySmallBluegray400,
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildThemeToggleCard(context),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildCard(context,
                      icon: ImageConstant.imgLogout,
                      title: "Log out", onTapCard: () {
                    logoutUser(context);
                  }),
                ),
                SizedBox(
                  height: 100.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildProfileDetails(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final profileState = ref.watch(profileScreenNotifier);
        final isUploading = profileState.isUploadingProfileImage;
        final profileImagePath = ref.watch(globalProfileImagePathProvider);
        final userName = ref.watch(userNameProvider);

        return SizedBox(
          width: double.maxFinite,
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: isUploading
                        ? null
                        : () {
                            requestCameraGalleryPermission(context);
                          },
                    child: UserAvatar(
                      imagePath: profileImagePath,
                      name: userName.asData?.value,
                      width: 50.h,
                      height: 50.h,
                    ),
                  ),

                  // Loading indicator overlay
                  if (isUploading)
                    Container(
                      width: 50.h,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(24.h),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 20.h,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: 16.h,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    NavigatorService.pushNamed(
                        AppRoutes.personalInformationScreen);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              userName.when(
                                data: (name) => Text(
                                  name ?? "John Doe",
                                  style: CustomTextStyles
                                      .titleMediumGray80001Medium,
                                ),
                                loading: () => Text(
                                  "Loading...",
                                  style: CustomTextStyles
                                      .titleMediumGray80001Medium,
                                ),
                                error: (_, __) => Text(
                                  "User",
                                  style: CustomTextStyles
                                      .titleMediumGray80001Medium,
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                "Profile Information",
                                style: CustomTextStyles.bodySmall110,
                              ),
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
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Common Widget
  Widget _buildCard(
    BuildContext context, {
    required String icon,
    required String title,
    Function? onTapCard,
  }) {
    return GestureDetector(
      onTap: () {
        onTapCard?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withValues(alpha: 1),
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
                style: CustomTextStyles.labelLargeMedium
                    .copyWith(color: appTheme.gray80001),
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
      ),
    );
  }

  Widget _buildThemeToggleCard(BuildContext context) {
    final themeType =
        ref.watch(themeNotifier.select((state) => state.themeType));
    final isDarkMode = ThemeHelper.isDarkThemeType(themeType);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 1),
      ),
      child: Row(
        children: [
          Container(
            height: 30.h,
            width: 30.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: theme.colorScheme.primary,
              size: 18.h,
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDarkMode ? "Dark mode" : "Light mode",
                  style: CustomTextStyles.labelLargeMedium.copyWith(
                    color: appTheme.gray80001,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Updates app colors, maps, and device status bar",
                  style: CustomTextStyles.bodySmallBluegray40012,
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isDarkMode,
            activeThumbColor: theme.colorScheme.primary,
            onChanged: (value) {
              ref.read(themeNotifier.notifier).changeTheme(
                    value ? AppThemeTypes.darkCode : AppThemeTypes.lightCode,
                  );
            },
          ),
        ],
      ),
    );
  }

  // Requests permission to access the camera and storage, and displays a dialog for selecting images
  // Allows user to choose between camera and gallery
  requestCameraGalleryPermission(BuildContext context) async {
    // Request permissions
    await PermissionManager.requestPermission(Permission.camera);
    await PermissionManager.requestPermission(Permission.storage);

    // Show modern bottom sheet to choose between camera and gallery
    if (!mounted) return;

    AppBottomSheet.show(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.h),
              topRight: Radius.circular(24.h),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Change Profile Picture',
                    style: CustomTextStyles.titleMediumGray80001Bold,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: appTheme.gray600),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Choose how you want to upload your profile picture',
                style: CustomTextStyles.bodyMediumGray600,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _buildUploadOption(
                      context,
                      icon: Icons.camera_alt_outlined,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _uploadFromCamera(context);
                      },
                    ),
                  ),
                  SizedBox(width: 16.h),
                  Expanded(
                    child: _buildUploadOption(
                      context,
                      icon: Icons.image_outlined,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _uploadFromGallery(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: appTheme.gray50,
          borderRadius: BorderRadius.circular(16.h),
          border: Border.all(color: appTheme.deepPurple50, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 28.h),
            SizedBox(height: 12.h),
            Text(
              label,
              style: CustomTextStyles.titleSmallGray80001,
            ),
          ],
        ),
      ),
    );
  }

  // Upload profile image from camera
  Future<void> _uploadFromCamera(BuildContext context) async {
    final notifier = ref.read(profileScreenNotifier.notifier);
    final success = await notifier.selectAndUploadProfileImage(useCamera: true);

    if (mounted) {
      if (success) {
        Fluttertoast.showToast(msg: 'Profile picture updated successfully!');
      } else {
        final error = ref.read(profileScreenNotifier).profileImageError;
        Fluttertoast.showToast(
            msg: error ?? 'Failed to upload profile picture');
      }
    }
  }

  // Upload profile image from gallery
  Future<void> _uploadFromGallery(BuildContext context) async {
    final notifier = ref.read(profileScreenNotifier.notifier);
    final success =
        await notifier.selectAndUploadProfileImage(useCamera: false);

    if (mounted) {
      if (success) {
        Fluttertoast.showToast(msg: 'Profile picture updated successfully!');
      } else {
        final error = ref.read(profileScreenNotifier).profileImageError;
        Fluttertoast.showToast(
            msg: error ?? 'Failed to upload profile picture');
      }
    }
  }

  onTapWallet(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.transactionHistoryScreen);
  }

  onTapReferFriends(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.referFriendsScren);
  }
}
