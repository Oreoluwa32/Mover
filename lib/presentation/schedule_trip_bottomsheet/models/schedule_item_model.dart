import '../../../core/app_export.dart';

// This class is used to create a model for the schedule item
// ignore for file, class must be immutable

class ScheduleItemModel {
  ScheduleItemModel({this.icon, this.title, this.id}) {
    icon = icon ?? ImageConstant.imgChatSquare;
    title = title ?? "Chat";
    id = id ?? "";
  }

  String? icon;

  String? title;

  String? id;

}