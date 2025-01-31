import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'schedule_item_model.dart';

// THis class is used to create a model for the schedule trip

// ignore for file, class must be immutable
class ScheduleTripModel extends Equatable {
  ScheduleTripModel({this.scheduleItemList = const []});

  List<ScheduleItemModel> scheduleItemList;

  ScheduleTripModel copyWith({
    List<ScheduleItemModel>? scheduleItemList,
  }) {
    return ScheduleTripModel(
      scheduleItemList: scheduleItemList ?? this.scheduleItemList,
    );
  }

  @override
  List<Object?> get props => [scheduleItemList];

}