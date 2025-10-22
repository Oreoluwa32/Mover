import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/quick_deposit_notifier.dart';

/// Quick Deposit Bottom Sheet - Shows immediately when user clicks "Deposit"
/// Collects amount and email, then navigates directly to payment WebView
class QuickDepositBottomsheet extends ConsumerStatefulWidget {
  const QuickDepositBottomsheet({Key? key}) : super(key: key);

  @override
  QuickDepositBottomsheetState createState() => QuickDepositBottomsheetState();
}

class QuickDepositBottomsheetState extends ConsumerState<QuickDepositBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withOpacity(1),
            borderRadius: BorderRadiusStyle.customBorderTL24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24.h),
              _buildTitle(context),
              SizedBox(height: 32.h),
              _buildAmountField(context),
              SizedBox(height: 16.h),
              _buildEmailField(context),
              SizedBox(height: 40.h),
              _buildButtonNav(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Title section
  Widget _buildTitle(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Deposit",
            style: CustomTextStyles.titleMediumGray80001,
          ),
          SizedBox(height: 4.h),
          Text(
            "Enter amount to deposit and proceed to payment",
            style: theme.textTheme.bodySmall?.copyWith(
              color: appTheme.gray600,
            ),
          ),
        ],
      ),
    );
  }

  /// Amount input field
  Widget _buildAmountField(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Amount (NGN)",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(height: 8.h),
          Consumer(
            builder: (context, ref, _) {
              return CustomTextFormField(
                controller: ref.watch(quickDepositNotifier).amountController,
                hintText: "Enter amount e.g. 5000",
                textInputType: TextInputType.number,
                prefix: Container(
                  margin: EdgeInsets.fromLTRB(14.h, 16.h, 12.h, 16.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgCreditCardGray,
                    height: 16.h,
                    width: 24.h,
                    fit: BoxFit.contain,
                  ),
                ),
                prefixConstraints: BoxConstraints(maxHeight: 50.h),
                contentPadding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 16.h),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Email input field
  Widget _buildEmailField(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email Address",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(height: 8.h),
          Consumer(
            builder: (context, ref, _) {
              return CustomTextFormField(
                controller: ref.watch(quickDepositNotifier).emailController,
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 16.h),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Bottom buttons (Pay Now / Cancel)
  Widget _buildButtonNav(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.h, 20.h, 16.h, 32.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          top: BorderSide(color: appTheme.gray20001, width: 1.h),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomElevatedButton(
            text: "Pay Now",
            buttonStyle: CustomButtonStyles.fillBlueGray,
            onPressed: () {
              _handleDepositPressed(context);
            },
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {
              NavigatorService.goBack();
            },
            child: Text(
              "Cancel",
              style: CustomTextStyles.bodySmallRedA700,
            ),
          )
        ],
      ),
    );
  }

  /// Handle deposit button press
  void _handleDepositPressed(BuildContext context) {
    final amountController = ref.read(quickDepositNotifier).amountController;
    final emailController = ref.read(quickDepositNotifier).emailController;

    final amount = amountController?.text.trim() ?? '';
    final email = emailController?.text.trim() ?? '';

    // Validate inputs
    if (amount.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter an amount',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    // Validate amount is a number
    if (double.tryParse(amount) == null) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid amount',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter your email',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    // Validate email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid email',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    // Generate unique transaction reference
    final reference = 'TXN-${DateTime.now().millisecondsSinceEpoch}';

    // Close the bottom sheet first
    NavigatorService.goBack();

    // Navigate to payment screen with all required parameters
    Future.delayed(Duration(milliseconds: 300), () {
      NavigatorService.pushNamed(
        AppRoutes.paystackPaymentScreen,
        arguments: {
          'amount': amount,
          'email': email,
          'reference': reference,
        },
      );
    });
  }
}