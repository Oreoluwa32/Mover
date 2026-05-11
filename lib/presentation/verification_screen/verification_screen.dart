import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/app_toast.dart';
import '../../data/services/account_api_service.dart';
import '../../presentation/home_screen_dialog/home_screen_dialog.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/movr_loading_indicator.dart';

enum _VerificationBadgeState {
  none,
  review,
  approved,
}

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends ConsumerState<VerificationScreen> {
  bool _isLoading = true;
  bool _isPersonalInfoComplete = false;
  _VerificationBadgeState _identificationStatus = _VerificationBadgeState.none;
  _VerificationBadgeState _vehicleStatus = _VerificationBadgeState.none;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVerificationState();
    });
  }

  Future<void> _loadVerificationState() async {
    final accountApiService = AccountApiService();
    try {
      final overview = await accountApiService.getMe();
      final user = Map<String, dynamic>.from(
        (overview['user'] as Map?) ?? const <String, dynamic>{},
      );
      final profile = Map<String, dynamic>.from(
        (overview['profile'] as Map?) ?? const <String, dynamic>{},
      );
      final kyc = overview['kyc'] is Map
          ? Map<String, dynamic>.from(overview['kyc'] as Map)
          : null;
      final vehicles = (overview['vehicles'] as List? ?? const [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _isPersonalInfoComplete = _resolvePersonalInfoComplete(user, profile);
        _identificationStatus = _resolveIdentificationStatus(kyc);
        _vehicleStatus = _resolveVehicleStatus(vehicles);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      AppToast.error(accountApiService.extractErrorMessage(error));
    }
  }

  bool _resolvePersonalInfoComplete(
    Map<String, dynamic> user,
    Map<String, dynamic> profile,
  ) {
    final hasFirstName =
        (user['first_name']?.toString().trim().isNotEmpty ?? false);
    final hasLastName =
        (user['last_name']?.toString().trim().isNotEmpty ?? false);
    final hasEmail = (user['email']?.toString().trim().isNotEmpty ?? false);
    return hasFirstName && hasLastName && hasEmail;
  }

  _VerificationBadgeState _resolveIdentificationStatus(
    Map<String, dynamic>? kyc,
  ) {
    if (kyc == null) {
      return _VerificationBadgeState.none;
    }

    final hasNin = (kyc['nin']?.toString().trim().isNotEmpty ?? false);
    final hasBvn = (kyc['bvn']?.toString().trim().isNotEmpty ?? false);
    if (!hasNin || !hasBvn) {
      return _VerificationBadgeState.none;
    }

    final status = (kyc['status']?.toString().toLowerCase() ?? '').trim();
    if (status == 'verified') {
      return _VerificationBadgeState.approved;
    }
    return _VerificationBadgeState.review;
  }

  _VerificationBadgeState _resolveVehicleStatus(
    List<Map<String, dynamic>> vehicles,
  ) {
    if (vehicles.isEmpty) {
      return _VerificationBadgeState.none;
    }

    final hasVerifiedVehicle = vehicles.any(
      (vehicle) => vehicle['is_verified'] == true,
    );
    return hasVerifiedVehicle
        ? _VerificationBadgeState.approved
        : _VerificationBadgeState.review;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _isLoading
          ? Center(
              child: MovrLoadingIndicator(
                label: 'Loading verification...',
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadVerificationState,
              child: ListView(
                padding: EdgeInsets.only(
                  left: 16.h,
                  top: 28.h,
                  right: 16.h,
                  bottom: 24.h,
                ),
                children: [
                  _buildVerificationRow(
                    label: 'Personal Information',
                    badgeState: _isPersonalInfoComplete
                        ? _VerificationBadgeState.approved
                        : _VerificationBadgeState.none,
                    onTap: () => onTapPersonalInfo(context),
                  ),
                  SizedBox(height: 28.h),
                  _buildVerificationRow(
                    label: 'Identification',
                    badgeState: _identificationStatus,
                    onTap: () => onTapIdentification(context),
                  ),
                  SizedBox(height: 28.h),
                  _buildVerificationRow(
                    label: 'Vehicle Identification',
                    badgeState: _vehicleStatus,
                    onTap: () => onTapVehicleInfo(context),
                  ),
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
          onTapLeftArrow1(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Verification",
      ),
      styleType: Style.bgOutline,
    );
  }

  Widget _buildVerificationRow({
    required String label,
    required _VerificationBadgeState badgeState,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.h),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
        ),
        child: SizedBox(
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: CustomTextStyles.bodyMediumMulishBlack900.copyWith(
                    color: appTheme.gray80001,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildStatusBadge(badgeState),
              SizedBox(width: 18.h),
              CustomImageView(
                imagePath: ImageConstant.imgBlackChevronRight,
                height: 16.h,
                width: 16.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(_VerificationBadgeState badgeState) {
    switch (badgeState) {
      case _VerificationBadgeState.approved:
        return CustomImageView(
          imagePath: ImageConstant.imgCheck,
          height: 22.h,
          width: 22.h,
        );
      case _VerificationBadgeState.review:
        return CustomImageView(
          imagePath: ImageConstant.imgReview,
          height: 28.h,
          width: 82.h,
          fit: BoxFit.contain,
        );
      case _VerificationBadgeState.none:
        return SizedBox(width: 22.h);
    }
  }

  void onTapLeftArrow1(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.homeOneScreen);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => HomeScreenDialog(),
        );
      }
    });
  }

  Future<void> onTapPersonalInfo(BuildContext context) async {
    await Navigator.pushNamed(context, AppRoutes.personalInformationScreen);
    if (mounted) {
      _loadVerificationState();
    }
  }

  Future<void> onTapVehicleInfo(BuildContext context) async {
    await Navigator.pushNamed(context, AppRoutes.vehicleInformationScreen);
    if (mounted) {
      _loadVerificationState();
    }
  }

  Future<void> onTapIdentification(BuildContext context) async {
    await Navigator.pushNamed(context, AppRoutes.identificationScreen);
    if (mounted) {
      _loadVerificationState();
    }
  }
}
