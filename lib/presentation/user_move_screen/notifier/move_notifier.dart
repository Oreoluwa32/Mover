import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/list_item_model.dart';
import '../models/listsendpackage_item_model.dart';
import '../models/move_model.dart';
part 'move_state.dart';

final moveNotifier = StateNotifierProvider.autoDispose<MoveNotifier, MoveState>(
  (ref) => MoveNotifier(MoveState(
    moveModelObj: MoveModel(listsendpackageItemList: [
      ListsendpackageItemModel(
        title: "Send a package",
        description: "Use the power of people's daily journeys to ensure swift and reliable deliveries.",
        titleImg: ImageConstant.imgDeliveryBike
      ),
      ListsendpackageItemModel(
        title: "Share a ride",
        description: "Connect with fellow movers heading in the same direction, making every commute a collaborative adventure.",
        titleImg: ImageConstant.imgDeliveryCar,
      ),
      ListsendpackageItemModel(
        title: "Schedule trips",
        description: "Simplify your day with ease. Plan your deliveries and trips by using the power of people's daily routes.",
        titleImg: ImageConstant.imgScheduleRoute,
      ),
    ], listItemList: [
      ListItemModel(image: ImageConstant.imgAds1),
      ListItemModel(image: ImageConstant.imgAds1)
    ]),
  )),
);

// A notifier that manages the state of the screen accroding to the event that is dispatched to it
class MoveNotifier extends StateNotifier{
  MoveNotifier(MoveState state) : super(state);
}