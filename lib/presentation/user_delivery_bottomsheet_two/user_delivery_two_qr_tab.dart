import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/user_delivery_two_qr_model.dart';
import 'notifier/user_delivery_two_notifier.dart';

class UserDeliveryTwoQrTab extends ConsumerStatefulWidget {
  const UserDeliveryTwoQrTab({Key? key}) : super(key: key);

  @override
  UserDeliveryTwoQrTabState createState() => UserDeliveryTwoQrTabState();
}

class UserDeliveryTwoQrTabState extends ConsumerState<UserDeliveryTwoQrTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 26.h,
        vertical: 16.h,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 14.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                CustomImageView(
                  imagePath: ImageConstant.imgQRCode2,
                  height: 200.h,
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 58.h),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
