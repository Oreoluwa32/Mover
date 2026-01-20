import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/vehicle_info_model.dart';
part 'vehicle_info_state.dart';

final vehicleInfoNotifier =
    StateNotifierProvider.autoDispose<VehicleInfoNotifier, VehicleInfoState>(
  (ref) => VehicleInfoNotifier(VehicleInfoState(
    plateNumber: TextEditingController(),
    selectedDropDownValue: SelectionPopupModel(title: ''),
    selectedDropDownValue1: SelectionPopupModel(title: ''),
    selectedDropDownValue2: SelectionPopupModel(title: ''),
    vehicleInfoModelObj: VehicleInfoModel(dropdownItemList: [
      SelectionPopupModel(
        id: 1,
        title: "Car",
        isSelected: false,
      ),
      SelectionPopupModel(
        id: 2,
        title: "Bike",
      ),
      SelectionPopupModel(
        id: 3,
        title: "Truck",
      ),
    ], dropdownItemList1: [
      SelectionPopupModel(
        id: 1,
        title: "Toyota",
        isSelected: false,
      ),
      SelectionPopupModel(
        id: 2,
        title: "Honda",
      ),
      SelectionPopupModel(
        id: 3,
        title: "Nissan",
      ),
    ], dropdownItemList2: [
      SelectionPopupModel(
        id: 1,
        title: "Black",
        isSelected: false,
      ),
      SelectionPopupModel(
        id: 2,
        title: "White",
      ),
      SelectionPopupModel(
        id: 3,
        title: "Gray",
      ),
      SelectionPopupModel(
        id: 4,
        title: "Blue",
      ),
      SelectionPopupModel(
        id: 5,
        title: "Red",
      ),
    ]),
  )),
);

// A notifier that manages the state of vehicle info according to the event dispatched to it
class VehicleInfoNotifier extends StateNotifier<VehicleInfoState> {
  VehicleInfoNotifier(VehicleInfoState state) : super(state);

  void uploadVehiclePhoto(String imagePath) {
    state = state.copyWith(vehiclePhotoPath: imagePath);
  }

  void uploadVehicleReport(String imagePath) {
    state = state.copyWith(vehicleReportPath: imagePath);
  }

  void uploadDriverLicense(String imagePath) {
    state = state.copyWith(driverLicensePath: imagePath);
  }

  void uploadVehicleInsurance(String imagePath) {
    state = state.copyWith(vehicleInsurancePath: imagePath);
  }

  void onSelected(SelectionPopupModel value) {
    state = state.copyWith(selectedDropDownValue: value);
  }

  void onSelected1(SelectionPopupModel value) {
    state = state.copyWith(selectedDropDownValue1: value);
  }

  void onSelected2(SelectionPopupModel value) {
    state = state.copyWith(selectedDropDownValue2: value);
  }
}
