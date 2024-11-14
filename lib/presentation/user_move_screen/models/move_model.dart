import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'list_item_model.dart';
import 'listsendpackage_item_model.dart';

// This class defines the variables used in the move screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class MoveModel extends Equatable{
  MoveModel({
    this.listsendpackageItemList = const [],
    this.listItemList = const []
  });
  List<ListsendpackageItemModel> listsendpackageItemList;
  List<ListItemModel> listItemList;

  MoveModel copyWith({
    List<ListsendpackageItemModel>? listsendpackageItemList,
    List<ListItemModel>? listItemList,
  }) {
    return MoveModel(
      listsendpackageItemList: listsendpackageItemList ?? this.listsendpackageItemList,
      listItemList: listItemList ?? this.listItemList,
    );
  }

  @override
  List<Object?> get props => [listsendpackageItemList, listItemList];
}