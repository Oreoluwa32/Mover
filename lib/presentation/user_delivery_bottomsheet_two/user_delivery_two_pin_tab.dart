import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/user_delivery_two_pin_model.dart';
import 'notifier/user_delivery_two_notifier.dart';

class UserDeliveryTwoPinTab extends ConsumerStatefulWidget {
  const UserDeliveryTwoPinTab({Key? key}) : super(key: key);

  @override
  UserDeliveryTwoPinTabState createState() => UserDeliveryTwoPinTabState();
}

class UserDeliveryTwoPinTabState extends ConsumerState<UserDeliveryTwoPinTab> {
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
                SizedBox(
                  height: 20.h,
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
