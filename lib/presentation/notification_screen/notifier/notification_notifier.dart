import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/list_item_model.dart';
import '../models/notification_model.dart';
part 'notification_state.dart';

final notificationNotifier = StateNotifierProvider.autoDispose<NotificationNotifier, NotificationState>(
  (ref) => NotificationNotifier(
    NotificationState(
      notificationModelObj: NotificationModel(
        listItemList: [
          ListItemModel(
            time: "Mon, 14, 12:00 PM",
            title: "Account Update",
            message: "Your account has been updated successfully. Thank you for moving with Movr.",
          ),
          ListItemModel(
            time: "Mon, 14, 12:00 PM",
            title: "Account Update",
            message: "Your account has been updated successfully. Thank you for moving with Movr.",
          ),
          ListItemModel(
            time: "Mon, 14, 12:00 PM",
            title: "Account Update",
            message: "Your account has been updated successfully. Thank you for moving with Movr.",
          ),
          ListItemModel(
            time: "Mon, 14, 12:00 PM",
            title: "Account Update",
            message: "Your account has been updated successfully. Thank you for moving with Movr.",
          ),
          ListItemModel(
            time: "Mon, 14, 12:00 PM",
            title: "Account Update",
            message: "Your account has been updated successfully. Thank you for moving with Movr.",
          ),
          ListItemModel(
            time: "Mon, 14, 12:00 PM",
            title: "Account Update",
            message: "Your account has been updated successfully. Thank you for moving with Movr.",
          ),
          ListItemModel(
            time: "Mon, 14, 12:00 PM",
            title: "Account Update",
            message: "Your account has been updated successfully. Thank you for moving with Movr.",
          ),
        ],
      ),
    ),
  ),
);

class NotificationNotifier extends StateNotifier<NotificationState>{
  NotificationNotifier(NotificationState state) : super(state);
}