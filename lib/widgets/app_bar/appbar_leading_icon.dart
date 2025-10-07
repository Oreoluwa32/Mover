import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../custom_icon_button.dart';

class AppbarLeadingIcon extends StatelessWidget{
  AppbarLeadingIcon({
    Key? key,
    this.imagePath,
    this.height,
    this.width,
    this.onTap,
    this.margin
  }) : super(key: key);

  final String? imagePath;

  final double? height;

  final double? width;

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: CustomIconButton(
          height: height ?? 48.h,
          width: width ?? 48.h,
          padding: EdgeInsets.all(12.h),
          decoration: IconButtonStyleHelper.outlineBlackTL241,
          child: CustomImageView(
            imagePath: ImageConstant.imgChevronLeft,
          ),
        ),
      ),
    );
  }
}