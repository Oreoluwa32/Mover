import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/ride_sharing_item_model.dart';
import '../models/ride_sharing_pickup_model.dart';
part 'ride_sharing_pickup_state.dart';

final rideSharingPickupNotifier = StateNotifierProvider.autoDispose<RideSharingPickupNotifier, RideSharingPickupState>(
  (ref) => RideSharingPickupNotifier(
    RideSharingPickupState(
      rideSharingPickupModelObj: RideSharingPickupModel(
        rideSharingItemList: [
          RideSharingItemModel(
            title: "Chat",
            icon: ImageConstant.imgChatSquare,
          ),
          RideSharingItemModel(
            title: "Call",
            icon: ImageConstant.imgPhoneCall,
          ),
          RideSharingItemModel(
            title: "Report",
            icon: ImageConstant.imgAlertCircle,
          ),
        ]
      )
    )
  )
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class RideSharingPickupNotifier extends StateNotifier<RideSharingPickupState>{
  RideSharingPickupNotifier(RideSharingPickupState state) : super(state); 
}