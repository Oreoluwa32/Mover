import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/activity_scheduled_model.dart';
import '../models/scheduled_item_model.dart';
part 'activity_scheduled_state.dart';

final activityScheduledNotifier = StateNotifierProvider.autoDispose<ActivityScheduledNotifier, ActivityScheduledState>(
  (ref) => ActivityScheduledNotifier(ActivityScheduledState(
    activityScheduledModelObj: ActivityScheduledModel(
      scheduledItemList: [
        ScheduledItemModel(
          icon: ImageConstant.imgPackageBlack,
          address: "Lagos, Nigeria",
          date: "13 Jan",
          time: "12:00",
          status: "Scheduled",
          moverName: "John Doe",
          rating: "No ratings or reviews",
          price: "₦2000.00",
        ),
        ScheduledItemModel(
          icon: ImageConstant.imgBlackCar,
          address: "Lagos, Nigeria",
          date: "13 Jan",
          time: "12:00",
          status: "Scheduled",
          moverName: "John Doe",
          rating: "No ratings or reviews",
          price: "₦2000.00",
        ),
      ]
    ),
  )),
);

// A notifier class that is used to manage the state of the activity progress screen according to the event that is dispatched to it
class ActivityScheduledNotifier extends StateNotifier<ActivityScheduledState>{
  ActivityScheduledNotifier(ActivityScheduledState state) : super(state);
}