part of 'activity_progress_notifier.dart';

// Represents the state of the activity progress screen
// ignore for file, class must be immutable
class ActivityProgressState extends Equatable{
  ActivityProgressState({
    this.activityInProgressModelObj,
    this.activityProgressTabModelObj,
    this.isLoading = false,
    this.errorMessage,
  });

  ActivityInProgressModel? activityInProgressModelObj;

  ActivityProgressTabModel? activityProgressTabModelObj;
  bool isLoading;
  String? errorMessage;

  @override
  List<Object?> get props => [
        activityInProgressModelObj,
        activityProgressTabModelObj,
        isLoading,
        errorMessage,
      ];
  ActivityProgressState copyWith({
    ActivityInProgressModel? activityInProgressModelObj,
    ActivityProgressTabModel? activityProgressTabModelObj,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ActivityProgressState(
      activityInProgressModelObj: activityInProgressModelObj ?? this.activityInProgressModelObj,
      activityProgressTabModelObj: activityProgressTabModelObj ?? this.activityProgressTabModelObj,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
