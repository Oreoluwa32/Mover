import '../../../core/app_export.dart';

// This class is used in the list item widget
// ignore for file, class must be immutble
class ListItemModel {
  ListItemModel({
    this.time,
    this.title,
    this.message,
    this.id
  }) {
    time = time ?? "Mon, 14, 12:00 PM";
    title = title ?? "Account Update";
    message = message ?? "Your account has been updated successfully. Thank you for moving with Movr.";
    id = id ?? "";
  }

  String? time;
  String? title;
  String? message;
  String? id;

  ListItemModel copyWith({
    String? time,
    String? title,
    String? message,
    String? id
  }) {
    return ListItemModel(
      time: time ?? this.time,
      title: title ?? this.title,
      message: message ?? this.message,
      id: id ?? this.id
    );
  }

  @override
  List<Object?> get props => [time, title, message, id];
}