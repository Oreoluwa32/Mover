import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'ride_sharing_item_model.dart';

// This class defines the variables used in the screen and is typically used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class RideSharingPickupModel extends Equatable{
  RideSharingPickupModel({this.rideSharingItemList = const []});

  List<RideSharingItemModel> rideSharingItemList;

  RideSharingPickupModel copyWith({
    List<RideSharingItemModel>? rideSharingItemList,
  }) {
    return RideSharingPickupModel(
      rideSharingItemList: rideSharingItemList ?? this.rideSharingItemList,
    );
  }

  @override
  List<Object?> get props => [rideSharingItemList];
}