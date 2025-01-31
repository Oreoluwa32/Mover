part of 'activity_completed_notifier.dart';

// Represents the state of the activity progress screen
// ignore for file, class must be immutable

class ActivityCompletedState extends Equatable{
  ActivityCompletedState({this.activityCompletedModelObj});

  ActivityCompletedModel? activityCompletedModelObj;

  @override
  List<Object?> get props => [activityCompletedModelObj];
  ActivityCompletedState copyWith({
    ActivityCompletedModel? activityCompletedModelObj
  }) {
    return ActivityCompletedState(
      activityCompletedModelObj: activityCompletedModelObj ?? this.activityCompletedModelObj,
    );
  }
}