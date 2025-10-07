import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'list_item_model.dart';

// This class defines the variables used in the notification screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutbale
class NotificationModel extends Equatable{
  NotificationModel({this.listItemList = const []});

  List<ListItemModel> listItemList;

  NotificationModel copyWith({List<ListItemModel>? listItemList}) {
    return NotificationModel(
      listItemList: listItemList ?? this.listItemList
    );
  }

  @override
  List<Object?> get props => [listItemList];
}