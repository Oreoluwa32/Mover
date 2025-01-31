part of 'activity_scheduled_notifier.dart';

// Represents the state of the activity progress screen
// ignore for file, class must be immutable

class ActivityScheduledState extends Equatable{
  ActivityScheduledState({this.activityScheduledModelObj});

  ActivityScheduledModel? activityScheduledModelObj;

  @override
  List<Object?> get props => [activityScheduledModelObj];
  ActivityScheduledState copyWith({
    ActivityScheduledModel? activityScheduledModelObj
  }) {
    return ActivityScheduledState(
      activityScheduledModelObj: activityScheduledModelObj ?? this.activityScheduledModelObj,
    );
  }
}