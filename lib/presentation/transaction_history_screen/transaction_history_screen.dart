import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/movr_loading_indicator.dart';
import 'models/balance_item_model.dart';
import 'models/month_trans_item_model.dart';
import 'models/transaction_item_model.dart';
import 'notifier/trans_history_notifier.dart';
import 'widgets/balance_item_widget.dart';
import 'widgets/month_trans_item_widget.dart';
import 'widgets/transaction_item_widget.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  TransactionHistoryScreenState createState() =>
      TransactionHistoryScreenState();
}

class TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(transHistoryNotifier).isLoading;

    return Scaffold(
      extendBody: true,
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: _buildAppbar(context),
      body: isLoading
          ? const Center(child: MovrLoadingIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(transHistoryNotifier.notifier).fetchWalletData();
                await ref
                    .read(transHistoryNotifier.notifier)
                    .fetchFundingAccount();
              },
              child: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        SizedBox(height: 24.h),
                        _buildBalance(context),
                        SizedBox(height: 24.h),
                        _buildButtons(context),
                        SizedBox(height: 18.h),
                        _buildFundingAccountCard(context),
                        SizedBox(height: 26.h),
                        _buildMonthTrans(context),
                        SizedBox(height: 14.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.h),
                            child: Text(
                              "Recent Transactions",
                              style: CustomTextStyles.bodySmallErrorContainer,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        _buildTrans(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 60.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeftBlack,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(text: "Wallet"),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildBalance(BuildContext context) {
    return Container(
        height: 146.h,
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 8.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Consumer(
              builder: (context, ref, _) {
                return CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 149.h,
                    initialPage: 0,
                    viewportFraction: 1.0,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      ref
                          .read(transHistoryNotifier.notifier)
                          .changeSliderIndex(index);
                    },
                  ),
                  itemCount: ref
                          .watch(transHistoryNotifier)
                          .transactionHistoryModelObj
                          ?.balanceList
                          .length ??
                      0,
                  itemBuilder: (context, index, realIndex) {
                    BalanceItemModel model = ref
                            .watch(transHistoryNotifier)
                            .transactionHistoryModelObj
                            ?.balanceList[index] ??
                        BalanceItemModel();
                    return BalanceItemWidget(model);
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Consumer(
                builder: (context, ref, _) {
                  return Container(
                    height: 6.h,
                    margin: EdgeInsets.only(bottom: 24.h),
                    child: AnimatedSmoothIndicator(
                      activeIndex: ref.watch(transHistoryNotifier).sliderIndex,
                      count: ref
                              .watch(transHistoryNotifier)
                              .transactionHistoryModelObj
                              ?.balanceList
                              .length ??
                          0,
                      axisDirection: Axis.horizontal,
                      effect: ScrollingDotsEffect(
                        spacing: 4,
                        activeDotColor: theme.colorScheme.onPrimary,
                        dotColor:
                            theme.colorScheme.onPrimary.withValues(alpha: 0.4),
                        dotHeight: 6.h,
                        dotWidth: 6.h,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }

  // Section Widget
  Widget _buildMonthTrans(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final monthTransList = ref
                .watch(transHistoryNotifier)
                .transactionHistoryModelObj
                ?.monthTransList ??
            [];
        if (monthTransList.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.h),
                child: Text(
                  "Transactions",
                  style: CustomTextStyles.bodySmallErrorContainer,
                ),
              ),
              SizedBox(height: 12.h),
              ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  MonthTransItemModel model = monthTransList[index];
                  return MonthTransItemWidget(
                    model,
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8.h);
                },
                itemCount: monthTransList.length,
              )
            ],
          ),
        );
      },
    );
  }

  // Section Widget
  Widget _buildTrans(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final transactionList = ref
                .watch(transHistoryNotifier)
                .transactionHistoryModelObj
                ?.transactionList ??
            [];

        if (transactionList.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: Text(
                "No transactions yet",
                style: CustomTextStyles.bodySmallErrorContainer,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            TransactionItemModel model = transactionList[index];
            return TransactionItemWidget(
              model,
            );
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0.h),
              child: Divider(
                height: 1.h,
                thickness: 1.h,
                color: appTheme.gray200,
              ),
            );
          },
          itemCount: transactionList.length,
        );
      },
    );
  }

  // Section Widget
  Widget _buildButtons(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              text: "Deposit",
              leftIcon: Container(
                padding: EdgeInsets.all(8.h),
                margin: EdgeInsets.only(right: 8.h),
                decoration: BoxDecoration(
                    color: appTheme.deepPurple50,
                    borderRadius: BorderRadius.circular(16.h)),
                child: CustomImageView(
                  imagePath: ImageConstant.imgPurpleCirclePlus,
                  height: 14.h,
                  width: 14.h,
                  fit: BoxFit.contain,
                ),
              ),
              buttonStyle: CustomButtonStyles.fillGray,
              buttonTextStyle: CustomTextStyles.titleSmallInterPrimary,
              onPressed: () {
                // ✅ NEW: Show quick deposit bottom sheet immediately
                onTapDeposit(context);
              },
            ),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: CustomElevatedButton(
              text: "Withdraw",
              leftIcon: Container(
                padding: EdgeInsets.all(8.h),
                margin: EdgeInsets.only(right: 8.h),
                decoration: BoxDecoration(
                    color: appTheme.indigo5002,
                    borderRadius: BorderRadius.circular(16.h)),
                child: CustomImageView(
                  imagePath: ImageConstant.imgBlueCirclePLus,
                  height: 14.h,
                  width: 14.h,
                  fit: BoxFit.contain,
                ),
              ),
              buttonStyle: CustomButtonStyles.fillGrayTL8,
              buttonTextStyle: CustomTextStyles.titleSmallInterPrimaryIndigo500,
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Withdrawals stay on the existing wallet flow for now.",
                  toastLength: Toast.LENGTH_SHORT,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundingAccountCard(BuildContext context) {
    final state = ref.watch(transHistoryNotifier);
    final fundingAccount = state.fundingAccount;

    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(16.h),
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
          Row(
            children: [
              Container(
                height: 36.h,
                width: 36.h,
                decoration: BoxDecoration(
                  color: appTheme.deepPurple50,
                  borderRadius: BorderRadius.circular(18.h),
                ),
                child: Icon(
                  Icons.account_balance_outlined,
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
                      "Dedicated funding account",
                      style: CustomTextStyles.titleSmallGray80001,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Transfer into this account and your wallet updates automatically.",
                      style: CustomTextStyles.bodySmallBluegray40012,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (state.fundingAccountLoading)
            const Center(child: MovrLoadingIndicator(size: 48))
          else if (fundingAccount != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFundingAccountRow(
                  label: "Bank",
                  value: fundingAccount.bankName ?? "--",
                ),
                _buildFundingAccountRow(
                  label: "Account number",
                  value: fundingAccount.accountNumber ?? "--",
                  actionLabel: "Copy",
                  onActionTap: () {
                    _copyToClipboard(
                      fundingAccount.accountNumber ?? "",
                      "Account number copied",
                    );
                  },
                ),
                _buildFundingAccountRow(
                  label: "Account name",
                  value: fundingAccount.accountName ?? "--",
                ),
                if ((fundingAccount.accountReference ?? "").isNotEmpty)
                  _buildFundingAccountRow(
                    label: "Reference",
                    value: fundingAccount.accountReference ?? "--",
                    actionLabel: "Copy",
                    onActionTap: () {
                      _copyToClipboard(
                        fundingAccount.accountReference ?? "",
                        "Account reference copied",
                      );
                    },
                  ),
                SizedBox(height: 12.h),
                Text(
                  "Status: ${(fundingAccount.status ?? 'ACTIVE').replaceAll('_', ' ')}",
                  style: CustomTextStyles.bodySmallBluegray40012,
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.fundingAccountError ??
                      "Create your Monnify account details to fund this wallet with bank transfer.",
                  style: CustomTextStyles.bodySmallBluegray40012,
                ),
                SizedBox(height: 14.h),
                CustomElevatedButton(
                  text: "Create funding account",
                  buttonStyle: CustomButtonStyles.fillGray,
                  buttonTextStyle: CustomTextStyles.titleSmallInterPrimary,
                  onPressed: () async {
                    try {
                      await ref
                          .read(transHistoryNotifier.notifier)
                          .provisionFundingAccount();
                      Fluttertoast.showToast(
                        msg: "Funding account is ready.",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    } catch (error) {
                      Fluttertoast.showToast(
                        msg: error.toString().replaceFirst('Exception: ', ''),
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFundingAccountRow({
    required String label,
    required String value,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104.h,
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
          if (actionLabel != null && onActionTap != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionLabel,
                style: CustomTextStyles.labelLargePurple900,
              ),
            ),
        ],
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }

  /// ✅ NEW: Show quick deposit bottom sheet
  /// Displays amount and email input, then navigates directly to payment WebView
  // Opens the dedicated Monnify transfer screen
  onTapDeposit(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.monnifyPaymentScreen);
  }

  Future<void> _copyToClipboard(String value, String successMessage) async {
    if (value.isEmpty) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: value));
    Fluttertoast.showToast(
      msg: successMessage,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
