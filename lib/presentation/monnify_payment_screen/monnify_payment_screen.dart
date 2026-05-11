import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../../core/utils/app_toast.dart';
import '../../data/models/wallet_model.dart';
import '../../data/services/wallet_api_service.dart';
import '../notification_screen/notifier/notification_notifier.dart';
import '../transaction_history_screen/notifier/trans_history_notifier.dart';
import '../wallet/notifier/wallet_notifier.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/movr_loading_indicator.dart';

class MonnifyPaymentScreen extends ConsumerStatefulWidget {
  final String? amount;
  final String? email;
  final String? reference;

  const MonnifyPaymentScreen({
    super.key,
    this.amount,
    this.email,
    this.reference,
  });

  @override
  MonnifyPaymentScreenState createState() => MonnifyPaymentScreenState();
}

class MonnifyPaymentScreenState extends ConsumerState<MonnifyPaymentScreen>
    with WidgetsBindingObserver {
  WalletFundingAccount? _fundingAccount;
  bool _isLoading = true;
  String? _error;
  Timer? _pollingTimer;
  final DateTime _monitoringStartedAt = DateTime.now();
  String? _lastDetectedFundingReference;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadFundingAccount();
    _startPolling();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshFundingStatus(silent: true));
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => unawaited(_refreshFundingStatus(silent: true)),
    );
  }

  Future<void> _loadFundingAccount({bool autoProvision = true}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final apiService = ref.read(walletApiServiceProvider);
    try {
      final existingAccount = await apiService.fetchFundingAccount();
      if (!mounted) return;
      if (existingAccount != null) {
        setState(() {
          _fundingAccount = existingAccount;
          _isLoading = false;
        });
        await _refreshFundingStatus(silent: true);
        return;
      }

      if (!autoProvision) {
        setState(() {
          _isLoading = false;
          _fundingAccount = null;
        });
        return;
      }

      final createdAccount = await apiService.provisionFundingAccount();
      if (!mounted) return;
      setState(() {
        _fundingAccount = createdAccount;
        _isLoading = false;
      });
      await _refreshFundingStatus(silent: true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _refreshFundingStatus({bool silent = false}) async {
    try {
      final walletData =
          await ref.read(walletApiServiceProvider).fetchWalletData();
      final transactions =
          walletData.transactions ?? const <WalletTransaction>[];
      final recentFunding = transactions
          .where(_isSuccessfulWalletFunding)
          .where(
              (transaction) => _wasCreatedAfterMonitoringStarted(transaction))
          .toList()
        ..sort((left, right) {
          final leftDate = DateTime.tryParse(left.createdAt ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final rightDate = DateTime.tryParse(right.createdAt ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return rightDate.compareTo(leftDate);
        });

      if (recentFunding.isEmpty) {
        return;
      }

      final latestFunding = recentFunding.first;
      final currentReference = latestFunding.reference ?? latestFunding.id;
      if (currentReference == null ||
          currentReference == _lastDetectedFundingReference) {
        return;
      }

      _lastDetectedFundingReference = currentReference;
      ref.invalidate(walletBalanceProvider);
      ref.invalidate(walletNotifierProvider);
      ref.invalidate(transHistoryNotifier);
      unawaited(ref
          .read(notificationNotifier.notifier)
          .refreshNotifications(silent: true));

      if (!mounted || silent) {
        return;
      }

      final amount = double.tryParse(latestFunding.amount ?? '0') ?? 0;
      AppToast.success(
        'Wallet funded successfully with NGN ${amount.toStringAsFixed(2)}.',
      );
    } catch (_) {
      // Best-effort polling only; avoid disrupting the funding screen.
    }
  }

  bool _isSuccessfulWalletFunding(WalletTransaction transaction) {
    final type = (transaction.type ?? '').toLowerCase();
    final status = (transaction.status ?? '').toLowerCase();
    final relatedType = (transaction.relatedType ?? '').toLowerCase();
    final description = (transaction.description ?? '').toLowerCase();
    return type == 'deposit' &&
        status == 'success' &&
        (relatedType == 'wallet_top_up' ||
            description.contains('wallet funding'));
  }

  bool _wasCreatedAfterMonitoringStarted(WalletTransaction transaction) {
    final createdAt = DateTime.tryParse(transaction.createdAt ?? '');
    if (createdAt == null) {
      return false;
    }
    return !createdAt.isBefore(_monitoringStartedAt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => _loadFundingAccount(autoProvision: false),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.h, 24.h, 16.h, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroCard(),
              SizedBox(height: 20.h),
              if (_isLoading)
                Center(
                  child: MovrLoadingIndicator(
                    size: 42.h,
                    label: 'Loading funding details...',
                  ),
                )
              else if (_fundingAccount != null)
                _buildFundingDetails(context)
              else
                _buildEmptyState(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 60.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeftBlack,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          NavigatorService.goBack();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: 'Fund Wallet',
      ),
      styleType: Style.bgOutline,
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(18.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            appTheme.deepPurpleA100,
          ],
        ),
        borderRadius: BorderRadius.circular(24.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42.h,
            width: 42.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(21.h),
            ),
            child: Icon(
              Icons.account_balance_outlined,
              color: Colors.white,
              size: 20.h,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Monnify bank transfer",
            style: CustomTextStyles.titleMediumOnPrimary,
          ),
          SizedBox(height: 6.h),
          Text(
            "Use your personal account details below. Every successful transfer lands in your Movr wallet automatically.",
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundingDetails(BuildContext context) {
    final fundingAccount = _fundingAccount!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailsCard(
          title: "Your account details",
          children: [
            _buildDetailRow(
              label: "Bank",
              value: fundingAccount.bankName ?? "--",
            ),
            _buildDetailRow(
              label: "Account number",
              value: fundingAccount.accountNumber ?? "--",
              trailingLabel: "Copy",
              onTrailingTap: () {
                _copyValue(
                  fundingAccount.accountNumber ?? "",
                  "Account number copied",
                );
              },
            ),
            _buildDetailRow(
              label: "Account name",
              value: fundingAccount.accountName ?? "--",
            ),
            _buildDetailRow(
              label: "Reference",
              value: fundingAccount.accountReference ?? "--",
              trailingLabel: "Copy",
              onTrailingTap: () {
                _copyValue(
                  fundingAccount.accountReference ?? "",
                  "Account reference copied",
                );
              },
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildDetailsCard(
          title: "How it works",
          children: [
            _buildInstruction(
                "1. In sandbox, complete the transfer with Monnify's Payment Simulator."),
            _buildInstruction(
                "2. In live mode, transfer any amount from your bank app into this account."),
            _buildInstruction(
                "3. Movr watches the Monnify callback and updates your wallet automatically."),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: CustomElevatedButton(
                text: "Copy account number",
                buttonStyle: CustomButtonStyles.fillGray,
                buttonTextStyle: CustomTextStyles.titleSmallInterPrimary,
                onPressed: () {
                  _copyValue(
                    fundingAccount.accountNumber ?? "",
                    "Account number copied",
                  );
                },
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: CustomElevatedButton(
                text: "Refresh",
                buttonStyle: CustomButtonStyles.fillGray,
                buttonTextStyle: CustomTextStyles.titleSmallInterPrimary,
                onPressed: () {
                  _loadFundingAccount(autoProvision: false);
                  unawaited(_refreshFundingStatus());
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20.h),
        border: Border.all(
          color: appTheme.gray200,
          width: 1.h,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "We couldn't prepare your funding account yet",
            style: CustomTextStyles.titleSmallGray80001,
          ),
          SizedBox(height: 8.h),
          Text(
            _error ??
                "Try again in a moment. If this keeps happening, your KYC details may still be incomplete.",
            style: CustomTextStyles.bodySmallBluegray40012,
          ),
          SizedBox(height: 20.h),
          CustomElevatedButton(
            text: "Try again",
            buttonStyle: CustomButtonStyles.fillGray,
            buttonTextStyle: CustomTextStyles.titleSmallInterPrimary,
            onPressed: () {
              _loadFundingAccount();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(18.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20.h),
        border: Border.all(
          color: appTheme.gray200,
          width: 1.h,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomTextStyles.titleSmallGray80001,
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    String? trailingLabel,
    VoidCallback? onTrailingTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.h,
            child: Text(
              label,
              style: CustomTextStyles.bodySmallBluegray40012,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: CustomTextStyles.labelLargeMedium.copyWith(
                color: appTheme.gray80001,
              ),
            ),
          ),
          if (trailingLabel != null && onTrailingTap != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Text(
                trailingLabel,
                style: CustomTextStyles.labelLargePurple900,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInstruction(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        text,
        style: CustomTextStyles.bodySmallBluegray40012,
      ),
    );
  }

  Future<void> _copyValue(String value, String successMessage) async {
    if (value.isEmpty) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: value));
    AppToast.success(successMessage);
  }
}
