import '../../../core/app_export.dart';

// This class is used in the list item widget
// ignore for file, class must be immutble
class ListItemModel {
  ListItemModel({
    this.time,
    this.title,
    this.message,
    this.id,
    this.createdAt,
    this.isRead,
    this.actionType,
    this.actionArguments,
  }) {
    time = time ?? "Mon, 14, 12:00 PM";
    title = title ?? "Account Update";
    message = message ?? "Your account has been updated successfully. Thank you for moving with Movr.";
    id = id ?? "";
    createdAt = createdAt ?? "";
    isRead = isRead ?? false;
    actionType = actionType ?? '';
    actionArguments = actionArguments ?? const <String, dynamic>{};
  }

  String? time;
  String? title;
  String? message;
  String? id;
  String? createdAt;
  bool? isRead;
  String? actionType;
  Map<String, dynamic>? actionArguments;

  ListItemModel copyWith({
    String? time,
    String? title,
    String? message,
    String? id,
    String? createdAt,
    bool? isRead,
    String? actionType,
    Map<String, dynamic>? actionArguments,
  }) {
    return ListItemModel(
      time: time ?? this.time,
      title: title ?? this.title,
      message: message ?? this.message,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionType: actionType ?? this.actionType,
      actionArguments: actionArguments ?? this.actionArguments,
    );
  }

  @override
  List<Object?> get props => [
        time,
        title,
        message,
        id,
        createdAt,
        isRead,
        actionType,
        actionArguments,
      ];
}
