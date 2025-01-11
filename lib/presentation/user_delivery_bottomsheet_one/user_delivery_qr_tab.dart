import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/user_delivery_qrtab_model.dart';
import 'notifier/user_delivery_notifier.dart';

class UserDeliveryQrTab extends ConsumerStatefulWidget {
  const UserDeliveryQrTab({Key? key}) : super(key: key);

  @override
  UserDeliveryQrTabState createState() => UserDeliveryQrTabState();
}

class UserDeliveryQrTabState extends ConsumerState<UserDeliveryQrTab> {
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
                Text(
                  "Confirm the item picked up by allowing the mover scan",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bodyMediumMulishGray800
                      .copyWith(height: 1.20),
                ),
                SizedBox(
                  height: 37.h,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgQRCode,
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
