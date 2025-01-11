import 'package:equatable/equatable.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class RideSharingDetailsModel extends Equatable {
  RideSharingDetailsModel({this.dropdownItemList = const []});

  List<SelectionPopupModel> dropdownItemList;

  RideSharingDetailsModel copyWith(
      {List<SelectionPopupModel>? dropdownItemList}) {
    return RideSharingDetailsModel(
        dropdownItemList: dropdownItemList ?? this.dropdownItemList);
  }

  @override
  List<Object?> get props => [dropdownItemList];
}
