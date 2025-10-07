import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'notifier/splash_screen_three_notifier.dart';

class SplashScreenThree extends ConsumerStatefulWidget{
  const SplashScreenThree({Key? key})
  : super(key: key,);

  @override
  SplashScreenThreeState createState() => SplashScreenThreeState();
}

class SplashScreenThreeState extends ConsumerState<SplashScreenThree> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  final int screenIndex = 1;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_progressController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          onTapNext(context);
        }
      });
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.maxFinite,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgSplashScreenThree,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 40.h,
            ),
            child: Column(children: [
              _buildRowline(context),
              Spacer(flex: 78,),
              _buildColumnyouarein(context),
              Spacer(flex: 21,)
            ],),
          ),
        ),
      );
  }

  // Section Widget
  Widget _buildRowline(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              height: 6.h,
              margin: index < 2 ? EdgeInsets.only(right: 12.h) : null,
              child: Stack(
                children: [
                  Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: appTheme.gray700,
                      borderRadius: BorderRadius.circular(3.h),
                    ),
                  ),
                  if (index < screenIndex)
                    Container(
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3.h),
                      ),
                    )
                  else if (index == screenIndex)
                    FractionallySizedBox(
                      widthFactor: _progressAnimation.value,
                      child: Container(
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3.h),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Section Widget
  Widget _buildColumnyouarein(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Text(
            "You are in Control",
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 14.h),
          Text(
              "Choose when, where and how you want to move. You can also choose the best price.",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeOnPrimary.copyWith(
                height: 1.50,
              ),
            ),
          SizedBox(height: 24.h),
          CustomElevatedButton(
            text: "Next",
            buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
            onPressed: () {onTapNext(context);},
          ),
          SizedBox(height: 22.h),
          GestureDetector(
            onTap: () {onTapBack(context);},
            child: Text(
              "Back",
              style: theme.textTheme.titleSmall,
            ),
          )
        ],
      ),
    );
  }

  // Navigates to the splash screen four when the action is triggered
  onTapNext(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.splashScreenFour);
  }

  // Navigates back to the splash screen two when the action is triggered
  onTapBack(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.splashScreenTwo);
  }
}