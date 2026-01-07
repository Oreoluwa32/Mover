part of 'add_route_two_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class AddRouteTwoState extends Equatable {
  AddRouteTwoState(
      {this.locationController,
      this.stopController,
      this.destinationController,
      this.setDateController,
      this.setTimeController,
      this.setTimeBeginController,
      this.setTimeEndController,
      this.routeNameController,
      this.serviceDropdownValue,
      this.repeatDropdownValue,
      this.maxCapDropdownValue,
      this.radioGroup = "",
      this.returnRadio = "",
      this.setTime,
      this.imagePath,
      this.showStopField = false,
      this.addRouteTwoModelObj});

  TextEditingController? locationController;
  TextEditingController? stopController;
  TextEditingController? destinationController;
  TextEditingController? setDateController;
  TextEditingController? setTimeController;
  TextEditingController? setTimeBeginController;
  TextEditingController? setTimeEndController;
  TextEditingController? routeNameController;
  SelectionPopupModel? serviceDropdownValue;
  SelectionPopupModel? repeatDropdownValue;
  SelectionPopupModel? maxCapDropdownValue;
  AddRouteTwoModel? addRouteTwoModelObj;
  String radioGroup;
  String returnRadio;
  TimeOfDay? setTime;
  String? imagePath;
  bool showStopField;

  @override
  List<Object?> get props => [
        locationController,
        stopController,
        destinationController,
        setDateController,
        setTimeController,
        setTimeBeginController,
        setTimeEndController,
        routeNameController,
        serviceDropdownValue,
        repeatDropdownValue,
        maxCapDropdownValue,
        radioGroup,
        returnRadio,
        setTime,
        imagePath,
        showStopField,
        addRouteTwoModelObj
      ];
  AddRouteTwoState copyWith(
      {TextEditingController? locationController,
      TextEditingController? stopController,
      TextEditingController? destinationController,
      TextEditingController? setDateController,
      TextEditingController? setTimeController,
      TextEditingController? setTimeBeginController,
      TextEditingController? setTimeEndController,
      TextEditingController? routeNameController,
      SelectionPopupModel? serviceDropdownValue,
      SelectionPopupModel? repeatDropdownValue,
      SelectionPopupModel? maxCapDropdownValue,
      AddRouteTwoModel? addRouteTwoModelObj,
      String? radioGroup,
      String? returnRadio,
      TimeOfDay? setTime,
      String? imagePath,
      bool? showStopField}) {
    return AddRouteTwoState(
        locationController: locationController ?? this.locationController,
        stopController: stopController ?? this.stopController,
        destinationController: destinationController ?? this.destinationController,
        setDateController: setDateController ?? this.setDateController,
        setTimeController: setTimeController ?? this.setTimeController,
        setTimeBeginController:
            setTimeBeginController ?? this.setTimeBeginController,
        setTimeEndController: setTimeEndController ?? this.setTimeEndController,
        routeNameController: routeNameController ?? this.routeNameController,
        serviceDropdownValue: serviceDropdownValue ?? this.serviceDropdownValue,
        repeatDropdownValue: repeatDropdownValue ?? this.repeatDropdownValue,
        maxCapDropdownValue: maxCapDropdownValue ?? this.maxCapDropdownValue,
        radioGroup: radioGroup ?? this.radioGroup,
        returnRadio: returnRadio ?? this.returnRadio,
        setTime: setTime ?? this.setTime,
        imagePath: imagePath ?? this.imagePath,
        showStopField: showStopField ?? this.showStopField,
        addRouteTwoModelObj: addRouteTwoModelObj ?? this.addRouteTwoModelObj);
  }
}
