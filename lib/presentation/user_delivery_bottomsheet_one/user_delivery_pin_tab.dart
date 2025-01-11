import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/user_delivery_pintab_model.dart';
import 'notifier/user_delivery_notifier.dart';

class UserDeliveryPinTab extends ConsumerStatefulWidget {
  const UserDeliveryPinTab({Key? key}) : super(key: key);

  @override
  UserDeliveryPinTabState createState() => UserDeliveryPinTabState();
}

class UserDeliveryPinTabState extends ConsumerState<UserDeliveryPinTab> {
  bool _isPinVisible = false; // Track whether the PIN is visible or hidden

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
                SizedBox(height: 20.h),
                Text(
                  "Confirm the item picked up by giving your secret code to the mover",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bodyMediumMulishGray800
                      .copyWith(height: 1.20),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 30.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _isPinVisible
                            ? "265874" // Show the actual PIN when visible
                            : "******", // Show asterisks when hidden
                        style: theme.textTheme.titleMedium?.copyWith(
                          letterSpacing: 20.0,
                          color: Colors.black87,
                          fontSize: 34.h,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPinVisible = !_isPinVisible; // Toggle the state
                          });
                        },
                        child: CustomImageView(
                          imagePath: _isPinVisible
                              ? ImageConstant.imgEye // Open eye icon
                              : ImageConstant.imgEyeClosed, // Closed eye icon
                          height: 24.h,
                          width: 24.h,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
