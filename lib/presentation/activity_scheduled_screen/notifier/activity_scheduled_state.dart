part of 'activity_scheduled_notifier.dart';

// Represents the state of the activity progress screen
// ignore for file, class must be immutable

class ActivityScheduledState extends Equatable{
  ActivityScheduledState({
    this.activityScheduledModelObj,
    this.isLoading = false,
    this.errorMessage,
  });

  ActivityScheduledModel? activityScheduledModelObj;
  bool isLoading;
  String? errorMessage;

  @override
  List<Object?> get props => [activityScheduledModelObj, isLoading, errorMessage];
  ActivityScheduledState copyWith({
    ActivityScheduledModel? activityScheduledModelObj,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ActivityScheduledState(
      activityScheduledModelObj: activityScheduledModelObj ?? this.activityScheduledModelObj,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
