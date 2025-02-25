import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'notifier/account_funded_notifier.dart';

class AccountFundedScreen extends ConsumerStatefulWidget {
  const AccountFundedScreen({Key? key}) : super(key: key);

  @override
  AccountFundedScreenState createState() => AccountFundedScreenState();
}

class AccountFundedScreenState extends ConsumerState<AccountFundedScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Column(
            children: [
              Text(
                "Account Funded",
                style: CustomTextStyles.titleMediumGray80001,
              ),
              SizedBox(height: 78.h,),
              _buildFundAmount(context),
              SizedBox(height: 4.h,)
            ],
          ),
        ),
      ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 83.h,
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgCancel,
          margin: EdgeInsets.only(
            top: 40.h,
            right: 16.h,
            bottom: 16.h,
          ),
          onTap: () {
            NavigatorService.pushNamed(AppRoutes.homeOneScreen);
          },
        )
      ],
    );
  }

  // Section Widget
  Widget _buildFundAmount(BuildContext context) {
    return SizedBox(
      height: 200.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgGreenCheck,
            height: 96.h,
            width: double.maxFinite,
            alignment: Alignment.topCenter,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your wallet has been successfully funded with",
                  style: CustomTextStyles.bodySmallGray80001,
                ),
                SizedBox(height: 10.h,),
                Text(
                  "₦38,720.50",
                  style: CustomTextStyles.titleMediumGray80001,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}