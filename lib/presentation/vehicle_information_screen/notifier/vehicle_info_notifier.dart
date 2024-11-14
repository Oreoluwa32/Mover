import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/vehicle_info_model.dart';
part 'vehicle_info_state.dart';

final vehicleInfoNotifier = StateNotifierProvider.autoDispose<VehicleInfoNotifier, VehicleInfoState>(
  (ref) => VehicleInfoNotifier(VehicleInfoState(
    firstNameController: TextEditingController(),
    selectedDropDownValue: SelectionPopupModel(title: ''),
    selectedDropDownValue1: SelectionPopupModel(title: ''),
    selectedDropDownValue2: SelectionPopupModel(title: ''),
    vehicleInfoModelObj: VehicleInfoModel(dropdownItemList: [
      SelectionPopupModel(
        id: 1,
        title: "Item One",
        isSelected: false,
      ),
      SelectionPopupModel(
        id: 2,
        title: "Item Two",
      ),
      SelectionPopupModel(
        id: 3,
        title: "Item Three",
      ),
    ],
    dropdownItemList1: [
      SelectionPopupModel(
        id: 4,
        title: "Item One",
        isSelected: false,
      ),
      SelectionPopupModel(
        id: 5,
        title: "Item Two",
      ),
      SelectionPopupModel(
        id: 6,
        title: "Item Three",
      ),
    ],
    dropdownItemList2: [
      SelectionPopupModel(
        id: 7,
        title: "Item One",
        isSelected: false,
      ),
      SelectionPopupModel(
        id: 8,
        title: "Item Two",
      ),
      SelectionPopupModel(
        id: 9,
        title: "Item Three",
      ),
    ]),
  )),
);

// A notifier that manages the state of vehicle info according to the event dispatched to it
class VehicleInfoNotifier extends StateNotifier<VehicleInfoState>{
  VehicleInfoNotifier(VehicleInfoState state) : super(state);
}