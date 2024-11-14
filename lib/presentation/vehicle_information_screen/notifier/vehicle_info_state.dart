part of 'vehicle_info_notifier.dart';

// Represents the state of vehicle info in the app
// ignore for file, class must be immtable
class VehicleInfoState extends Equatable{
  VehicleInfoState({
    this.firstNameController,
    this.selectedDropDownValue,
    this.selectedDropDownValue1,
    this.selectedDropDownValue2,
    this.vehicleInfoModelObj,
  });

  TextEditingController? firstNameController;
  SelectionPopupModel? selectedDropDownValue;
  SelectionPopupModel? selectedDropDownValue1;
  SelectionPopupModel? selectedDropDownValue2;
  VehicleInfoModel? vehicleInfoModelObj;

  @override
  List<Object?> get props => [
    firstNameController,
    selectedDropDownValue,
    selectedDropDownValue1,
    selectedDropDownValue2,
    vehicleInfoModelObj
  ];
  VehicleInfoState copyWith({
    TextEditingController? firstNameController,
    SelectionPopupModel? selectedDropDownValue,
    SelectionPopupModel? selectedDropDownValue1,
    SelectionPopupModel? selectedDropDownValue2,
    VehicleInfoModel? vehicleInfoModelObj,
  }) {
    return VehicleInfoState(
      firstNameController: firstNameController ?? this.firstNameController,
      selectedDropDownValue: selectedDropDownValue ?? this.selectedDropDownValue,
      selectedDropDownValue1: selectedDropDownValue1 ?? this.selectedDropDownValue1,
      selectedDropDownValue2: selectedDropDownValue2 ?? this.selectedDropDownValue2,
      vehicleInfoModelObj: vehicleInfoModelObj ?? this.vehicleInfoModelObj,
    );
  }
}