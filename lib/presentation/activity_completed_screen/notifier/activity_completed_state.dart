part of 'activity_completed_notifier.dart';

// Represents the state of the activity progress screen
// ignore for file, class must be immutable

class ActivityCompletedState extends Equatable{
  ActivityCompletedState({
    this.activityCompletedModelObj,
    this.isLoading = false,
    this.errorMessage,
  });

  ActivityCompletedModel? activityCompletedModelObj;
  bool isLoading;
  String? errorMessage;

  @override
  List<Object?> get props => [activityCompletedModelObj, isLoading, errorMessage];
  ActivityCompletedState copyWith({
    ActivityCompletedModel? activityCompletedModelObj,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ActivityCompletedState(
      activityCompletedModelObj: activityCompletedModelObj ?? this.activityCompletedModelObj,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
