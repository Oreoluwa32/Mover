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
      this.returnDestination = "",
      this.isReturnTrip = false,
      this.setTime,
      this.imagePath,
      this.showStopField = false,
      this.locationLat,
      this.locationLng,
      this.stopLat,
      this.stopLng,
      this.destinationLat,
      this.destinationLng,
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
  String returnDestination;
  bool isReturnTrip;
  TimeOfDay? setTime;
  String? imagePath;
  bool showStopField;
  double? locationLat;
  double? locationLng;
  double? stopLat;
  double? stopLng;
  double? destinationLat;
  double? destinationLng;

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
        returnDestination,
        isReturnTrip,
        setTime,
        imagePath,
        showStopField,
        locationLat,
        locationLng,
        stopLat,
        stopLng,
        destinationLat,
        destinationLng,
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
      String? returnDestination,
      bool? isReturnTrip,
      TimeOfDay? setTime,
      String? imagePath,
      bool? showStopField,
      double? locationLat,
      double? locationLng,
      double? stopLat,
      double? stopLng,
      double? destinationLat,
      double? destinationLng}) {
    return AddRouteTwoState(
        locationController: locationController ?? this.locationController,
        stopController: stopController ?? this.stopController,
        destinationController:
            destinationController ?? this.destinationController,
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
        returnDestination: returnDestination ?? this.returnDestination,
        isReturnTrip: isReturnTrip ?? this.isReturnTrip,
        setTime: setTime ?? this.setTime,
        imagePath: imagePath ?? this.imagePath,
        showStopField: showStopField ?? this.showStopField,
        locationLat: locationLat ?? this.locationLat,
        locationLng: locationLng ?? this.locationLng,
        stopLat: stopLat ?? this.stopLat,
        stopLng: stopLng ?? this.stopLng,
        destinationLat: destinationLat ?? this.destinationLat,
        destinationLng: destinationLng ?? this.destinationLng,
        addRouteTwoModelObj: addRouteTwoModelObj ?? this.addRouteTwoModelObj);
  }
}
