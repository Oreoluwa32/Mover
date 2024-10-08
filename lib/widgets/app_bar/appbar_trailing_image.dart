import 'package:flutter/material.dart';
import 'package:new_project/widgets/custom_bottom_bar.dart';
import '../../core/app_export.dart';

class AppbarTrailingImage extends StatelessWidget{
  AppbarTrailingImage({Key? key, this.imagePath, this.margin, this.onTap})
    : super(key: key,);

  final String? imagePath;
  final EdgeInsetsGeometry? margin;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath!,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}