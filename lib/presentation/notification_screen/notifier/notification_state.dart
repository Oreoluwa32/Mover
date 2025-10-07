part of 'notification_notifier.dart';

// Represents the state of the notification in the app
// ignore for file, class must be immutable 
class NotificationState extends Equatable{
  NotificationState({this.notificationModelObj});

  NotificationModel? notificationModelObj;

  @override
  List<Object?> get props => [notificationModelObj];
  NotificationState copyWith({NotificationModel? notificationModelObj}) {
    return NotificationState(
      notificationModelObj: notificationModelObj ?? this.notificationModelObj
    );
  }
}