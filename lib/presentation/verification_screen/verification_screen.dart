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
  rejected,
}

class _VerificationRowState {
  const _VerificationRowState({
    required this.badgeState,
    this.note = '',
  });

  final _VerificationBadgeState badgeState;
  final String note;
}

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key}) : super();

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends ConsumerState<VerificationScreen> {
  bool _isLoading = true;
  bool _isPersonalInfoComplete = false;
  _VerificationRowState _identificationState = const _VerificationRowState(
    badgeState: _VerificationBadgeState.none,
  );
  _VerificationRowState _vehicleState = const _VerificationRowState(
    badgeState: _VerificationBadgeState.none,
  );

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
        _identificationState = _resolveIdentificationState(kyc);
        _vehicleState = _resolveVehicleState(vehicles);
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

  _VerificationRowState _resolveIdentificationState(
    Map<String, dynamic>? kyc,
  ) {
    if (kyc == null) {
      return const _VerificationRowState(
        badgeState: _VerificationBadgeState.none,
      );
    }

    final hasNin = (kyc['nin']?.toString().trim().isNotEmpty ?? false);
    final hasBvn = (kyc['bvn']?.toString().trim().isNotEmpty ?? false);
    if (!hasNin || !hasBvn) {
      return const _VerificationRowState(
        badgeState: _VerificationBadgeState.none,
      );
    }

    final status = (kyc['status']?.toString().toLowerCase() ?? '').trim();
    final reviewerNotes = (kyc['reviewer_notes']?.toString().trim() ?? '');
    if (status == 'verified') {
      return const _VerificationRowState(
        badgeState: _VerificationBadgeState.approved,
      );
    }
    if (status == 'rejected') {
      return _VerificationRowState(
        badgeState: _VerificationBadgeState.rejected,
        note: reviewerNotes.isNotEmpty
            ? reviewerNotes
            : 'Your identification needs another review.',
      );
    }
    return _VerificationRowState(
      badgeState: _VerificationBadgeState.review,
      note: reviewerNotes,
    );
  }

  _VerificationRowState _resolveVehicleState(
    List<Map<String, dynamic>> vehicles,
  ) {
    if (vehicles.isEmpty) {
      return const _VerificationRowState(
        badgeState: _VerificationBadgeState.none,
      );
    }

    final hasVerifiedVehicle = vehicles.cast<Map<String, dynamic>>().firstWhere(
          (vehicle) => vehicle['is_verified'] == true,
          orElse: () => const <String, dynamic>{},
        );
    if (hasVerifiedVehicle.isNotEmpty) {
      return const _VerificationRowState(
        badgeState: _VerificationBadgeState.approved,
      );
    }

    final rejectedVehicle = vehicles.cast<Map<String, dynamic>>().firstWhere(
          (vehicle) =>
              (vehicle['review_status']?.toString().toLowerCase() ?? '') ==
              'rejected',
          orElse: () => const <String, dynamic>{},
        );
    if (rejectedVehicle.isNotEmpty) {
      final reviewerNotes =
          (rejectedVehicle['reviewer_notes']?.toString().trim() ?? '');
      return _VerificationRowState(
        badgeState: _VerificationBadgeState.rejected,
        note: reviewerNotes.isNotEmpty
            ? reviewerNotes
            : 'Your vehicle documents need to be updated.',
      );
    }

    final reviewVehicle = vehicles.cast<Map<String, dynamic>>().firstWhere(
          (vehicle) =>
              (vehicle['review_status']?.toString().toLowerCase() ?? '') ==
                  'pending' ||
              vehicle['metadata'] is Map,
          orElse: () => const <String, dynamic>{},
        );
    if (reviewVehicle.isNotEmpty) {
      final reviewerNotes =
          (reviewVehicle['reviewer_notes']?.toString().trim() ?? '');
      return _VerificationRowState(
        badgeState: _VerificationBadgeState.review,
        note: reviewerNotes,
      );
    }

    return const _VerificationRowState(
      badgeState: _VerificationBadgeState.none,
    );
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
                    rowState: _VerificationRowState(
                      badgeState: _isPersonalInfoComplete
                          ? _VerificationBadgeState.approved
                          : _VerificationBadgeState.none,
                    ),
                    onTap: () => onTapPersonalInfo(context),
                  ),
                  SizedBox(height: 28.h),
                  _buildVerificationRow(
                    label: 'Identification',
                    rowState: _identificationState,
                    onTap: () => onTapIdentification(context),
                  ),
                  SizedBox(height: 28.h),
                  _buildVerificationRow(
                    label: 'Vehicle Identification',
                    rowState: _vehicleState,
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
    required _VerificationRowState rowState,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.h),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.maxFinite,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: CustomTextStyles.bodyMediumMulishBlack900
                              .copyWith(
                            color: appTheme.gray80001,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (rowState.note.trim().isNotEmpty) ...[
                          SizedBox(height: 6.h),
                          Text(
                            rowState.note.trim(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: rowState.badgeState ==
                                      _VerificationBadgeState.rejected
                                  ? appTheme.redA700
                                  : appTheme.gray600,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: _buildStatusBadge(rowState.badgeState),
                  ),
                  SizedBox(width: 18.h),
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgBlackChevronRight,
                      height: 16.h,
                      width: 16.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      case _VerificationBadgeState.rejected:
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.h,
            vertical: 5.h,
          ),
          decoration: BoxDecoration(
            color: appTheme.red50,
            borderRadius: BorderRadius.circular(999.h),
          ),
          child: Text(
            'Rejected',
            style: theme.textTheme.bodySmall?.copyWith(
              color: appTheme.redA700,
              fontWeight: FontWeight.w600,
            ),
          ),
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
