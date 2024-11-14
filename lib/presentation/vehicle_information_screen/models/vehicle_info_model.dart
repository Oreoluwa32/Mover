import 'package:equatable/equatable.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';

// This class defines the variables used in the vehicle info screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class VehicleInfoModel extends Equatable{
  VehicleInfoModel({
    this.dropdownItemList = const [],
    this.dropdownItemList1 = const [],
    this.dropdownItemList2 = const []
  });

  List<SelectionPopupModel> dropdownItemList;
  List<SelectionPopupModel> dropdownItemList1;
  List<SelectionPopupModel> dropdownItemList2;

  VehicleInfoModel copyWith({
    List<SelectionPopupModel>? dropdownItemList,
    List<SelectionPopupModel>? dropdownItemList1,
    List<SelectionPopupModel>? dropdownItemList2,
  }) {
    return VehicleInfoModel(
      dropdownItemList: dropdownItemList ?? this.dropdownItemList,
      dropdownItemList1: dropdownItemList1 ?? this.dropdownItemList1,
      dropdownItemList2: dropdownItemList2 ?? this.dropdownItemList2,
    );
  }

  @override 
  List<Object?> get props => [dropdownItemList, dropdownItemList1, dropdownItemList2];
}