part of 'ride_sharing_details_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class RideSharingDetailsState extends Equatable {
  RideSharingDetailsState(
      {this.selectedDropDownValue,
      this.radioGroup = "",
      this.rideSharingDetailsModelObj});

  SelectionPopupModel? selectedDropDownValue;
  RideSharingDetailsModel? rideSharingDetailsModelObj;
  String radioGroup;

  @override
  List<Object?> get props =>
      [selectedDropDownValue, radioGroup, rideSharingDetailsModelObj];
  RideSharingDetailsState copyWith(
      {SelectionPopupModel? selectedDropDownValue,
      String? radioGroup,
      RideSharingDetailsModel? rideSharingDetailsModelObj}) {
    return RideSharingDetailsState(
        selectedDropDownValue:
            selectedDropDownValue ?? this.selectedDropDownValue,
        radioGroup: radioGroup ?? this.radioGroup,
        rideSharingDetailsModelObj:
            rideSharingDetailsModelObj ?? this.rideSharingDetailsModelObj);
  }
}
