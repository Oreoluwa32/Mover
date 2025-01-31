part of 'activity_progress_notifier.dart';

// Represents the state of the activity progress screen
// ignore for file, class must be immutable
class ActivityProgressState extends Equatable{
  ActivityProgressState({this.activityInProgressModelObj, this.activityProgressTabModelObj});

  ActivityInProgressModel? activityInProgressModelObj;

  ActivityProgressTabModel? activityProgressTabModelObj;

  @override
  List<Object?> get props => [activityInProgressModelObj, activityProgressTabModelObj];
  ActivityProgressState copyWith({
    ActivityInProgressModel? activityInProgressModelObj,
    ActivityProgressTabModel? activityProgressTabModelObj
  }) {
    return ActivityProgressState(
      activityInProgressModelObj: activityInProgressModelObj ?? this.activityInProgressModelObj,
      activityProgressTabModelObj: activityProgressTabModelObj ?? this.activityProgressTabModelObj
    );
  }
}