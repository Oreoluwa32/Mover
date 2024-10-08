import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class SplashScreenTwo extends StatelessWidget{
  const SplashScreenTwo({Key? key})
  : super(key: key,);
  
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.maxFinite,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgSplashScreenTwo,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 40.h,
            ),
            child: Column(children: [
              _buildRowemptyone(context),
              Spacer(flex: 72,),
              _buildColumnnoone(context),
              Spacer(flex: 27,)
            ],),
          ),
        ),
      ),);
  }

  // Section Widget
  Widget _buildRowemptyone(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Row(children: [
        Expanded(
          child: Divider(
            color: appTheme.gray700,
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Divider(
            color: appTheme.gray700,
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Divider(
            color: appTheme.gray700,
          ),
        )
      ],),
    );
  }

  // Section Widget
  Widget _buildColumnnoone(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Text(
            "No. 1 Transportation Tool",
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "Explore cost-effective routes or contribute your own to our map network.",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeOnPrimary.copyWith(
                height: 1.50,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          CustomElevatedButton(
            text: "Next",
            buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
            onPressed: () {onTapNext(context);},
          )
        ],
      ),
    );
  }

  // Navigates to splash screen three when the action is triggered
  onTapNext(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.splashScreenThree);
  }
}