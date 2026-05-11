import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/app_export.dart';

class UserDeliveryTwoQrTab extends ConsumerStatefulWidget {
  const UserDeliveryTwoQrTab({
    Key? key,
    required this.qrData,
  }) : super(key: key);

  final String qrData;

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
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: 200.h,
                  child: Center(
                    child: QrImageView(
                      data: widget.qrData,
                      size: 200.h,
                      backgroundColor: Colors.white,
                    ),
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
