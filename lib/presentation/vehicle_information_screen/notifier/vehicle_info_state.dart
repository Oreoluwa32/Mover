part of 'vehicle_info_notifier.dart';

// Represents the state of vehicle info in the app
// ignore for file, class must be immtable
class VehicleInfoState extends Equatable {
  VehicleInfoState({
    this.plateNumber,
    this.selectedDropDownValue,
    this.selectedDropDownValue1,
    this.selectedDropDownValue2,
    this.vehiclePhotoPath,
    this.driverLicensePath,
    this.vehicleReportPath,
    this.vehicleInsurancePath,
    this.vehicleInfoModelObj,
  });

  TextEditingController? plateNumber;
  SelectionPopupModel? selectedDropDownValue;
  SelectionPopupModel? selectedDropDownValue1;
  SelectionPopupModel? selectedDropDownValue2;
  String? vehiclePhotoPath;
  String? driverLicensePath;
  String? vehicleReportPath;
  String? vehicleInsurancePath;
  VehicleInfoModel? vehicleInfoModelObj;

  @override
  List<Object?> get props => [
        plateNumber,
        selectedDropDownValue,
        selectedDropDownValue1,
        selectedDropDownValue2,
        vehiclePhotoPath,
        driverLicensePath,
        vehicleReportPath,
        vehicleInsurancePath,
        vehicleInfoModelObj
      ];
  VehicleInfoState copyWith({
    TextEditingController? plateNumber,
    SelectionPopupModel? selectedDropDownValue,
    SelectionPopupModel? selectedDropDownValue1,
    SelectionPopupModel? selectedDropDownValue2,
    String? vehiclePhotoPath,
    String? driverLicensePath,
    String? vehicleReportPath,
    String? vehicleInsurancePath,
    VehicleInfoModel? vehicleInfoModelObj,
  }) {
    return VehicleInfoState(
      plateNumber: plateNumber ?? this.plateNumber,
      selectedDropDownValue:
          selectedDropDownValue ?? this.selectedDropDownValue,
      selectedDropDownValue1:
          selectedDropDownValue1 ?? this.selectedDropDownValue1,
      selectedDropDownValue2:
          selectedDropDownValue2 ?? this.selectedDropDownValue2,
      vehiclePhotoPath: vehiclePhotoPath ?? this.vehiclePhotoPath,
      vehicleInsurancePath: vehicleInsurancePath ?? this.vehicleInsurancePath,
      vehicleReportPath: vehicleReportPath ?? this.vehicleReportPath,
      driverLicensePath: driverLicensePath ?? this.driverLicensePath,
      vehicleInfoModelObj: vehicleInfoModelObj ?? this.vehicleInfoModelObj,
    );
  }
}
