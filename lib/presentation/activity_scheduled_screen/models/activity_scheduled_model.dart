import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'scheduled_item_model.dart';

// This class defines the variables that are used in the ActivityScheduledModel class
// ignore for file, class must be immutable
class ActivityScheduledModel extends Equatable {
  ActivityScheduledModel({
    this.scheduledItemList = const [],
  });

  List<ScheduledItemModel> scheduledItemList;

  ActivityScheduledModel copyWith({
    List<ScheduledItemModel>? scheduledItemList,
  }) {
    return ActivityScheduledModel(
      scheduledItemList: scheduledItemList ?? this.scheduledItemList,
    );
  }

  @override
  List<Object?> get props => [scheduledItemList];
}