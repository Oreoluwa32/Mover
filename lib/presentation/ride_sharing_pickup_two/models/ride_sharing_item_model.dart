import '../../../core/app_export.dart';

// This class is used in the ride sharing pickup widget screen

// ignore for file, class must be immutable
class RideSharingItemModel{
  RideSharingItemModel({
    this.title,
    this.icon,
    this.id,
  }) {
    icon = icon ?? ImageConstant.imgChatSquare;
    title = title ?? "Chat";
    id = id ?? "";
  }

  String? title;
  String? icon;
  String? id;

  RideSharingItemModel copyWith({
    String? title,
    String? icon,
    String? id,
  }) {
    return RideSharingItemModel(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [title, icon, id];
}