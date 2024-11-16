import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/add_route_one_item_model.dart';
import '../models/add_route_one_model.dart';
part 'add_route_one_state.dart';

final addRouteOneNotifier = StateNotifierProvider.autoDispose<AddRouteOneNotifier, AddRouteOneState>(
  (ref) => AddRouteOneNotifier(AddRouteOneState(
    serviceTypeDropDownValue: SelectionPopupModel(title: ''),
    departureDropDownValue: SelectionPopupModel(title: ''),
    radioGroup: "",
    addRouteOneModelObj: AddRouteOneModel(transportMeansList: [
      AddRouteOneItemModel(
        meansImage: ImageConstant.imgWalkingMan,
        meansTitle: "Public"
      ),
      AddRouteOneItemModel(
        meansImage: ImageConstant.img3DBike,
        meansTitle: "Bike"
      ),
      AddRouteOneItemModel(
        meansImage: ImageConstant.img3DCar,
        meansTitle: "Car"
      ),
      AddRouteOneItemModel(
        meansImage: ImageConstant.img3DBus,
        meansTitle: "Bus"
      ),
      AddRouteOneItemModel(
        meansImage: ImageConstant.img3DPlane,
        meansTitle: "Airplane"
      ),
      AddRouteOneItemModel(
        meansImage: ImageConstant.img3DTrain,
        meansTitle: "Train"
      ),
      AddRouteOneItemModel(
        meansImage: ImageConstant.img3DTruck,
        meansTitle: "Truck"
      )
    ],
    serviceTypeDropdown: [
      SelectionPopupModel(
        id: 1,
        title: "Ride Sharing",
        isSelected: true,
      ),
      SelectionPopupModel(
        id: 2,
        title: "Delivery",
      )
    ],
    departureDropdown: [
      SelectionPopupModel(
        id: 1,
        title: "12:00pm",
        isSelected: true,
      ),
      SelectionPopupModel(
        id: 2,
        title: "12:30pm",
      ),
      SelectionPopupModel(
        id: 3,
        title: "1:00pm",
      )
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class AddRouteOneNotifier extends StateNotifier<AddRouteOneState>{
  AddRouteOneNotifier(AddRouteOneState state) : super(state);

  void changeRadioButton(String value) {
    state = state.copyWith(radioGroup: value);
  }

  void selectTransportMode(int index) {
    final updatedModes = state.addRouteOneModelObj?.transportMeansList.map((item) {
      // Update `isSelected` for the selected index
      final isSelected = state.addRouteOneModelObj?.transportMeansList.indexOf(item) == index;
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
}