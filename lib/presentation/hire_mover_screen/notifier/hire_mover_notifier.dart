import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/hire_mover_model.dart';
import '../models/mover_item_model.dart';
part 'hire_mover_state.dart';

final hireMoverNotifier = StateNotifierProvider.autoDispose<HireMoverNotifier, HireMoverState> (
  (ref) => HireMoverNotifier(HireMoverState(
    hireMoverModelObj: HireMoverModel(moverItemList: [
      MoverItemModel(
        profileImage: ImageConstant.imgProfile,
        moverName: "John Doe",
        homeAway: ImageConstant.imgHomeIcon,
        distance: "2km away",
        vehicleType: ImageConstant.imgBlackBike,
        price: "₦1000"
      ),
      MoverItemModel(
        profileImage: ImageConstant.imgProfile,
        moverName: "John Doe",
        homeAway: ImageConstant.imgHomeIcon,
        distance: "2km away",
        vehicleType: ImageConstant.imgBlackCar,
        price: "₦1000"
      ),
      MoverItemModel(
        profileImage: ImageConstant.imgProfile,
        moverName: "John Doe",
        homeAway: ImageConstant.imgHomeIcon,
        distance: "2km away",
        vehicleType: ImageConstant.imgBlackManWalk,
        price: "₦1000"
      ),
      MoverItemModel(
        profileImage: ImageConstant.imgProfile,
        moverName: "John Doe",
        homeAway: ImageConstant.imgHomeIcon,
        distance: "2km away",
        vehicleType: ImageConstant.imgBlackBike,
        price: "₦1000"
      ),
      MoverItemModel(
        profileImage: ImageConstant.imgProfile,
        moverName: "John Doe",
        homeAway: ImageConstant.imgHomeIcon,
        distance: "2km away",
        vehicleType: ImageConstant.imgBlackCar,
        price: "₦1000"
      ),
      MoverItemModel(
        profileImage: ImageConstant.imgProfile,
        moverName: "John Doe",
        homeAway: ImageConstant.imgHomeIcon,
        distance: "2km away",
        vehicleType: ImageConstant.imgBlackManWalk,
        price: "₦1000"
      ),
      MoverItemModel(
        profileImage: ImageConstant.imgProfile,
        moverName: "John Doe",
        homeAway: ImageConstant.imgHomeIcon,
        distance: "2km away",
        vehicleType: ImageConstant.imgBlackBike,
        price: "₦1000"
      ),
      MoverItemModel(
        profileImage: ImageConstant.imgProfile,
        moverName: "John Doe",
        homeAway: ImageConstant.imgHomeIcon,
        distance: "2km away",
        vehicleType: ImageConstant.imgBlackCar,
        price: "₦1000"
      ),
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class HireMoverNotifier extends StateNotifier<HireMoverState>{
  HireMoverNotifier(HireMoverState state) : super(state);
}