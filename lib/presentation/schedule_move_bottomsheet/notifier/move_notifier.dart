import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:new_project/presentation/user_move_screen/notifier/move_notifier.dart';
import '../../../core/app_export.dart';
import '../models/move_model.dart';
import '../models/move_item_model.dart';
part 'move_state.dart';

final moveNotifier = StateNotifierProvider.autoDispose<MoveNotifier, MoveState>(
  (ref) => MoveNotifier(MoveState(
    moveModelObj: MoveModel(moveItemList: [
      MoveItemModel(
          serviceIcon: ImageConstant.imgDeliveryBike,
          serviceTitle: "Delivery",
          serviceText:
              "Use people's daily journeys to ensure swift and reliable deliveries."),
      MoveItemModel(
          serviceIcon: ImageConstant.imgDeliveryCar,
          serviceTitle: "Share a ride",
          serviceText:
              "Connect with fellow movers heading in the same direction.")
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class MoveNotifier extends StateNotifier<MoveState> {
  MoveNotifier(MoveState state) : super(state);
}
