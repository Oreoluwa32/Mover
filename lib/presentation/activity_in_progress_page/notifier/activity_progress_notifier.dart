import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/activity_in_progress_model.dart';
import '../models/activity_progress_tab_model.dart';
import '../models/progress_item_model.dart';
part 'activity_progress_state.dart';

final activityProgressNotifier = StateNotifierProvider.autoDispose<ActivityProgressNotifier, ActivityProgressState>(
  (ref) => ActivityProgressNotifier(ActivityProgressState(
    activityProgressTabModelObj: ActivityProgressTabModel(
      progressList: [
        ProgressItemModel(
          icon: ImageConstant.imgPackageBlack,
          address: "Lagos, Nigeria",
          date: "13 Jan",
          time: "12:00",
          status: "In progress",
          moverName: "John Doe",
          rating: "No ratings or reviews",
          price: "₦2000.00",
        ),
        ProgressItemModel(
          icon: ImageConstant.imgBlackCar,
          address: "Lagos, Nigeria",
          date: "13 Jan",
          time: "12:00",
          status: "In progress",
          moverName: "John Doe",
          rating: "No ratings or reviews",
          price: "₦2000.00",
        ),
      ]
    ),
  )),
);

// A notifier class that is used to manage the state of the activity progress screen according to the event that is dispatched to it
class ActivityProgressNotifier extends StateNotifier<ActivityProgressState>{
  ActivityProgressNotifier(ActivityProgressState state) : super(state);
}