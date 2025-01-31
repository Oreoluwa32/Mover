import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/activity_completed_model.dart';
import '../models/completed_item_model.dart';
part 'activity_completed_state.dart';

final activityCompletedNotifier = StateNotifierProvider.autoDispose<ActivityCompletedNotifier, ActivityCompletedState>(
  (ref) => ActivityCompletedNotifier(ActivityCompletedState(
    activityCompletedModelObj: ActivityCompletedModel(
      completedItemList: [
        CompletedItemModel(
          icon: ImageConstant.imgPackageBlack,
          address: "Lagos, Nigeria",
          date: "13 Jan",
          time: "12:00",
          status: "Completed",
          moverName: "John Doe",
          rating: "No ratings or reviews",
          price: "₦2000.00",
        ),
        CompletedItemModel(
          icon: ImageConstant.imgBlackCar,
          address: "Lagos, Nigeria",
          date: "13 Jan",
          time: "12:00",
          status: "Completed",
          moverName: "John Doe",
          rating: "No ratings or reviews",
          price: "₦2000.00",
        ),
      ]
    ),
  )),
);

// A notifier class that is used to manage the state of the activity progress screen according to the event that is dispatched to it
class ActivityCompletedNotifier extends StateNotifier<ActivityCompletedState>{
  ActivityCompletedNotifier(ActivityCompletedState state) : super(state);
}