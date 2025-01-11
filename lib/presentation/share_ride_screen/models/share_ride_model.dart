import 'package:equatable/equatable.dart';
import 'movers_item_model.dart';

// This class defines the variables used in the screen and it is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class ShareRideModel extends Equatable {
  ShareRideModel({this.moverItemList = const []});

  List<MoversItemModel> moverItemList;

  ShareRideModel copyWith({List<MoversItemModel>? moverItemList}) {
    return ShareRideModel(moverItemList: moverItemList ?? this.moverItemList);
  }

  @override
  List<Object?> get props => [moverItemList];
}
