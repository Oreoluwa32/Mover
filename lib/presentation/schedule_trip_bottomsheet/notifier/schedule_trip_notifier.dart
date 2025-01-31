import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/schedule_item_model.dart';
import '../models/schedule_trip_model.dart';
part 'schedule_trip_state.dart';

final scheduleTripNotifier = StateNotifierProvider.autoDispose<ScheduleTripNotifier, ScheduleTripState>(
  (ref) => ScheduleTripNotifier(ScheduleTripState(
    scheduleTripModelObj: ScheduleTripModel(scheduleItemList: [
      ScheduleItemModel(
        icon: ImageConstant.imgChatSquare,
        title: "Chat",
      ),
      ScheduleItemModel(
        icon: ImageConstant.imgPhoneCall,
        title: "Call",
      ),
      ScheduleItemModel(
        icon: ImageConstant.imgAlertCircle,
        title: "Report",
      )
    ]),
  )),
);

// A notifier that manages the state of the schedule trip
class ScheduleTripNotifier extends StateNotifier<ScheduleTripState>{
  ScheduleTripNotifier(ScheduleTripState state) : super(state);
}