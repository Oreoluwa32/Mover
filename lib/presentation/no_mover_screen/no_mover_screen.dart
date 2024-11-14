import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import 'notifier/no_mover_notifier.dart';

class NoMoverScreen extends ConsumerStatefulWidget{
    const NoMoverScreen({Key? key})
        :super(key: key);

    @override
    NoMoverScreenState createState() => NoMoverScreenState();
}

class NoMoverScreenState extends ConsumerState<NoMoverScreen>{
    @override
    Widget build(BuildContext context){
        return SafeArea(
            child: Scaffold(
                appBar: _buildAppbar(context),
                body: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 28.h,
                    ),
                    child: Column(
                        children: [
                            _buildIllustr(context),
                            Spacer(),
                            CustomElevatedButton(
                                text: "Get notified",
                            ),
                            SizedBox(height: 52.h,)
                        ],
                    ),
                ),
            ),
        );
    }

    // Section Widget
    PreferredSizeWidget _buildAppbar(BuildContext context) {
        return CustomAppBar(
            height: 56.h,
            actions: [
                AppbarTrailingImage(
                    imagePath: ImageConstant.imgCancel,
                    margin: EdgeInsets.only(
                        top: 16.h,
                        right: 15.h,
                        bottom: 16.h,
                    ),
                )
            ],
        );
    }

    // Section Widget
    Widget _buildIllustr(BuildContext context) {
        return Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 2.h),
            child: Column(
                children: [
                    CustomImageView(
                        imagePath: ImageConstant.imgNoMover,
                        height: 200.h,
                        width: double.maxFinite,
                        margin: EdgeInsets.symmetric(horizontal: 80.h),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                        "No mover is heading your way",
                        style: CustomTextStyles.titleMediumGray8000118,
                    ),
                    SizedBox(height: 28.h,),
                    Text(
                        "To ensure you get to know when a mover is heading your way, simply click the 'Get Notified' button below and you'll be notified right away.",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.bodyMediumMulishGray800.copyWith(height: 1.50),
                    )
                ],
            ),
        );
    }
}