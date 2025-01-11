import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/add_route_item_model.dart';
import '../models/add_route_two_model.dart';
part 'add_route_two_state.dart';

final addRouteTwoNotifier =
    StateNotifierProvider.autoDispose<AddRouteTwoNotifier, AddRouteTwoState>(
  (ref) => AddRouteTwoNotifier(AddRouteTwoState(
    locationController: TextEditingController(),
    stopController: TextEditingController(),
    destinationController: TextEditingController(),
    setDateController: TextEditingController(),
    setTimeController: TextEditingController(),
    setTimeBeginController: TextEditingController(),
    setTimeEndController: TextEditingController(),
    serviceDropdownValue: SelectionPopupModel(title: ''),
    repeatDropdownValue: SelectionPopupModel(title: ''),
    maxCapDropdownValue: SelectionPopupModel(title: ''),
    radioGroup: "",
    returnRadio: "",
    addRouteTwoModelObj: AddRouteTwoModel(transportMeansList: [
      AddRouteItemModel(
          tabImage: ImageConstant.imgWalkingMan, tabTitle: "Public"),
      AddRouteItemModel(tabImage: ImageConstant.img3DBike, tabTitle: "Bike"),
      AddRouteItemModel(tabImage: ImageConstant.img3DCar, tabTitle: "Car"),
      AddRouteItemModel(tabImage: ImageConstant.img3DTruck, tabTitle: "Truck"),
      AddRouteItemModel(tabImage: ImageConstant.img3DBus, tabTitle: "Bus"),
      AddRouteItemModel(
          tabImage: ImageConstant.img3DPlane, tabTitle: "Airplane"),
      AddRouteItemModel(tabImage: ImageConstant.img3DTrain, tabTitle: "Train"),
    ], serviceDropdown: [
      SelectionPopupModel(id: 1, title: "Ride-sharing", isSelected: true),
      SelectionPopupModel(id: 2, title: "Delivery")
    ], repeatDropdown: [
      SelectionPopupModel(id: 1, title: "Do not repeat", isSelected: true),
      SelectionPopupModel(id: 2, title: "Repeat")
    ], maxCapDropdown: [
      SelectionPopupModel(id: 1, title: "2 seaters", isSelected: true),
      SelectionPopupModel(id: 2, title: "3 seaters"),
      SelectionPopupModel(id: 3, title: "4 seaters")
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class AddRouteTwoNotifier extends StateNotifier<AddRouteTwoState> {
  AddRouteTwoNotifier(AddRouteTwoState state) : super(state);

  void changeRadioBtn(String value) {
    state = state.copyWith(radioGroup: value);
  }

  void returnRouteBtn(String value) {
    state = state.copyWith(returnRadio: value);
  }

  void selectTransportMode(int index) {
    final updatedModes =
        state.addRouteTwoModelObj?.transportMeansList.map((item) {
      // Update `isSelected` for the selected index
      final isSelected =
          state.addRouteTwoModelObj?.transportMeansList.indexOf(item) == index;
      return AddRouteItemModel(
        tabImage: item.tabImage,
        tabTitle: item.tabTitle,
        id: item.id,
        isSelected: isSelected,
      );
    }).toList();

    state = state.copyWith(
      addRouteTwoModelObj: state.addRouteTwoModelObj?.copyWith(
        transportMeansList: updatedModes,
      ),
    );
  }

  // Update the state with the image path
  void uploadImage(String imagePath) {
    state = state.copyWith(imagePath: imagePath);
  }
}
