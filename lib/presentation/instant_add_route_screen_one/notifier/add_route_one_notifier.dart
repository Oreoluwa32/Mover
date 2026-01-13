import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/add_route_one_item_model.dart';
import '../models/add_route_one_model.dart';
part 'add_route_one_state.dart';

final addRouteOneNotifier =
    StateNotifierProvider.autoDispose<AddRouteOneNotifier, AddRouteOneState>(
  (ref) => AddRouteOneNotifier(AddRouteOneState(
    locationController: TextEditingController(),
    stopController: TextEditingController(),
    destinationController: TextEditingController(),
    serviceTypeDropDownValue: SelectionPopupModel(title: ''),
    setTimeController: TextEditingController(),
    radioGroup: "",
    showStopField: false,
    addRouteOneModelObj: AddRouteOneModel(transportMeansList: [
      AddRouteOneItemModel(
          meansImage: ImageConstant.imgWalkingMan, meansTitle: "Public"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DBike, meansTitle: "Bike"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DCar, meansTitle: "Car"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DBus, meansTitle: "Bus"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DPlane, meansTitle: "Airplane"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DTrain, meansTitle: "Train"),
      AddRouteOneItemModel(
          meansImage: ImageConstant.img3DTruck, meansTitle: "Truck")
    ], serviceTypeDropdown: [
      SelectionPopupModel(
        id: 1,
        title: "Ride Sharing",
        isSelected: true,
      ),
      SelectionPopupModel(
        id: 2,
        title: "Delivery",
      )
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class AddRouteOneNotifier extends StateNotifier<AddRouteOneState> {
  AddRouteOneNotifier(AddRouteOneState state) : super(state);

  void changeRadioButton(String value) {
    state = state.copyWith(radioGroup: value);
  }

  void changeRadioBtn(String value) {
    state = state.copyWith(radioGroup: value);
  }

  void selectTransportMode(int index) {
    final updatedModes =
        state.addRouteOneModelObj?.transportMeansList.map((item) {
      // Update `isSelected` for the selected index
      final isSelected =
          state.addRouteOneModelObj?.transportMeansList.indexOf(item) == index;
      return AddRouteOneItemModel(
        meansImage: item.meansImage,
        meansTitle: item.meansTitle,
        id: item.id,
        isSelected: isSelected,
      );
    }).toList();

    state = state.copyWith(
      addRouteOneModelObj: state.addRouteOneModelObj?.copyWith(
        transportMeansList: updatedModes,
      ),
    );
  }

  void toggleStopField() {
    state = state.copyWith(showStopField: !state.showStopField);
  }

  void selectServiceType(SelectionPopupModel service) {
    state = state.copyWith(serviceTypeDropDownValue: service);
  }

  void updateTimeField(String timeText) {
    state.setTimeController?.text = timeText;
    state = state.copyWith();
  }

  void setLocationCoordinates(double lat, double lng) {
    state = state.copyWith(
      locationLat: lat,
      locationLng: lng,
    );
  }

  void setDestinationCoordinates(double lat, double lng) {
    state = state.copyWith(
      destinationLat: lat,
      destinationLng: lng,
    );
  }
}
