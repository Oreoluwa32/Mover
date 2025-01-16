import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'move_item_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable

class MoveModel extends Equatable {
  MoveModel({this.moveItemList = const []});

  List<MoveItemModel> moveItemList;

  MoveModel copyWith({List<MoveItemModel>? moveItemList}) {
    return MoveModel(moveItemList: moveItemList ?? this.moveItemList);
  }

  @override
  List<Object?> get props => [moveItemList];
}
