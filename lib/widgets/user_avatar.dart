import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../core/utils/avatar_utils.dart';
import 'custom_image_view.dart';

class UserAvatar extends StatelessWidget {
  final String? imagePath;
  final String? name;
  final double height;
  final double width;
  final BorderRadius? radius;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  const UserAvatar({
    Key? key,
    this.imagePath,
    this.name,
    this.height = 50,
    this.width = 50,
    this.radius,
    this.textStyle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasImage = imagePath != null &&
        imagePath!.isNotEmpty &&
        imagePath != "null" &&
        !imagePath!.contains('img_default_profile.svg');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: radius ?? BorderRadius.circular(height / 2),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: ClipRRect(
          borderRadius: radius ?? BorderRadius.circular(height / 2),
          child: hasImage
              ? CustomImageView(
                  imagePath: imagePath,
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                )
              : Container(
                  alignment: Alignment.center,
                  color: AvatarUtils.getAvatarColor(name),
                  child: Text(
                    AvatarUtils.getNameInitials(name),
                    style: textStyle ??
                        TextStyle(
                          color: Colors.white,
                          fontSize: (height / 2.5).fSize,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
        ),
      ),
    );
  }
}
