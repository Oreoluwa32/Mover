import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'mover_item_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immuatable
class HireMoverModel extends Equatable{
  HireMoverModel({
    this.moverItemList = const []
  });

  List<MoverItemModel> moverItemList;

  HireMoverModel copyWith({List<MoverItemModel>? moverItemList}) {
    return HireMoverModel(
      moverItemList: moverItemList ?? this.moverItemList,
    );
  }

  @override
  List<Object?> get props => [moverItemList];
}