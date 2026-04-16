part of 'notification_notifier.dart';

// Represents the state of the notification in the app
// ignore for file, class must be immutable 
class NotificationState extends Equatable{
  NotificationState({
    this.notificationModelObj,
    this.isLoading = false,
    this.unreadCount = 0,
    this.errorMessage,
  });

  NotificationModel? notificationModelObj;
  bool isLoading;
  int unreadCount;
  String? errorMessage;

  @override
  List<Object?> get props => [notificationModelObj, isLoading, unreadCount, errorMessage];
  NotificationState copyWith({
    NotificationModel? notificationModelObj,
    bool? isLoading,
    int? unreadCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationState(
      notificationModelObj: notificationModelObj ?? this.notificationModelObj,
      isLoading: isLoading ?? this.isLoading,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
