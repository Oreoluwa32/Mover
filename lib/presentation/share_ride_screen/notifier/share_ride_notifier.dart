import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/movers_item_model.dart';
import '../models/share_ride_model.dart';
part 'share_ride_state.dart';

final shareRideNotifier =
    StateNotifierProvider.autoDispose<ShareRideNotifier, ShareRideState>(
  (ref) => ShareRideNotifier(ShareRideState(
    shareRideModelObj: ShareRideModel(moverItemList: [
      MoversItemModel(
          name: "Jane Doe",
          time: "Leaving 7:30 AM",
          distance: "4km away",
          vehicle: "Toyota Camry",
          plateNum: "EKY453YB",
          seats: "3 passengers capacity",
          price: "₦700"),
      MoversItemModel(
          name: "Jane Doe",
          time: "Leaving 7:30 AM",
          distance: "4km away",
          vehicle: "Toyota Camry",
          plateNum: "EKY453YB",
          seats: "3 passengers capacity",
          price: "₦700"),
      MoversItemModel(
          name: "Jane Doe",
          time: "Leaving 7:30 AM",
          distance: "4km away",
          vehicle: "Toyota Camry",
          plateNum: "EKY453YB",
          seats: "3 passengers capacity",
          price: "₦700"),
      MoversItemModel(
          name: "Jane Doe",
          time: "Leaving 7:30 AM",
          distance: "4km away",
          vehicle: "Toyota Camry",
          plateNum: "EKY453YB",
          seats: "3 passengers capacity",
          price: "₦700"),
      MoversItemModel(
          name: "Jane Doe",
          time: "Leaving 7:30 AM",
          distance: "4km away",
          vehicle: "Toyota Camry",
          plateNum: "EKY453YB",
          seats: "3 passengers capacity",
          price: "₦700"),
      MoversItemModel(
          name: "Jane Doe",
          time: "Leaving 7:30 AM",
          distance: "4km away",
          vehicle: "Toyota Camry",
          plateNum: "EKY453YB",
          seats: "3 passengers capacity",
          price: "₦700"),
      MoversItemModel(
          name: "Jane Doe",
          time: "Leaving 7:30 AM",
          distance: "4km away",
          vehicle: "Toyota Camry",
          plateNum: "EKY453YB",
          seats: "3 passengers capacity",
          price: "₦700")
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class ShareRideNotifier extends StateNotifier<ShareRideState> {
  ShareRideNotifier(ShareRideState state) : super(state);
}
