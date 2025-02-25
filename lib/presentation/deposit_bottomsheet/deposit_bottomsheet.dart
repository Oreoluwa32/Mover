import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/deposit_bottomsheet_notifier.dart'; //ignore for file, class must be immutable

class DepositBottomsheet extends ConsumerStatefulWidget {
  const DepositBottomsheet({Key? key}) : super(key: key);

  @override
  DepositBottomsheetState createState() => DepositBottomsheetState();
}

class DepositBottomsheetState extends ConsumerState<DepositBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.customBorderTL24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 34.h,
              ),
              _buildTitle(context),
              SizedBox(
                height: 24.h,
              ),
              _buildButtonnav(context)
            ],
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildCardNum(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(depositBottomsheetNotifier).cardNumController,
          hintText: "0000 0000 0000 0000",
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
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.h, vertical: 16.h),
        );
      },
    );
  }

  // Section Widget
  Widget _buildExpiry(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          readOnly: true,
          controller:
              ref.watch(depositBottomsheetNotifier).expiryDateController,
          hintText: "MM/YY",
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          onTap: () {
            onTapExpiryDate(context);
          },
        );
      },
    );
  }

  // Section Widget
  Widget _buildCvv(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(depositBottomsheetNotifier).cvvController,
          hintText: "123",
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
        );
      },
    );
  }

  // Section Widget
  Widget _buildName(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(depositBottomsheetNotifier).nameController,
          hintText: "Enter name on card",
          textInputAction: TextInputAction.done,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (!isText(value)) {
              return "Please enter valid text";
            }
            return null;
          },
        );
      },
    );
  }

  // Section Widget
  Widget _buildTitle(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          Text(
            "Add Debit/Credit Card",
            style: CustomTextStyles.titleMediumGray80001,
          ),
          SizedBox(
            height: 22.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Card number",
                  style: CustomTextStyles.labelLargeGray600,
                ),
                SizedBox(
                  height: 4.h,
                ),
                _buildCardNum(context),
                SizedBox(
                  height: 14.h,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expiry date",
                              style: CustomTextStyles.labelLargeGray600,
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            _buildExpiry(context)
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 12.h,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CVV",
                              style: CustomTextStyles.labelLargeGray600,
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            _buildCvv(context)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                Text(
                  "Name on card",
                  style: CustomTextStyles.labelLargeGray600,
                ),
                SizedBox(
                  height: 4.h,
                ),
                _buildName(context)
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildNext(BuildContext context) {
    return CustomElevatedButton(
      text: "Next",
      buttonStyle: CustomButtonStyles.fillBlueGray,
      onPressed: () {
        NavigatorService.pushNamed(AppRoutes.depositScreenTwo);
      },
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.h, 20.h, 16.h, 22.h),
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
          _buildNext(context),
          SizedBox(
            height: 22.h,
          ),
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

  // Displays a date picker dialog and updates the selected date in the [depositBottomsheetModelObj] object of the current [expiryDateController] if the user selectes a valid date
  // This function return a  `Future` that completes with `void`
  Future<void> onTapExpiryDate(BuildContext context) async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: ref
                .watch(depositBottomsheetNotifier)
                .depositBottomsheetModelObj!
                .enterExpiryDate ??
            DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month));
    if (dateTime != null) {
      ref
          .watch(depositBottomsheetNotifier)
          .depositBottomsheetModelObj!
          .enterExpiryDate = dateTime;
      ref.watch(depositBottomsheetNotifier).expiryDateController?.text =
          dateTime.format(pattern: dateTimeFormatPattern);
    }
  }
}
