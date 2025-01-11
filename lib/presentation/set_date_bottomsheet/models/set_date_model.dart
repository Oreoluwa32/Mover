import 'package:equatable/equatable.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import 'days_item_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class SetDateModel extends Equatable {
  SetDateModel(
      {this.startDate,
      this.setStartDate = "\"\"",
      this.repeatDropdown = const [],
      this.daysOfWeek = const [],
      this.endDate,
      this.setEndDate = "\"\""}) {
    startDate = startDate ?? DateTime.now();
    endDate = endDate ?? DateTime.now();
  }

  DateTime? startDate;
  String setStartDate;
  List<SelectionPopupModel> repeatDropdown;
  List<DaysItemModel> daysOfWeek;
  DateTime? endDate;
  String setEndDate;

  SetDateModel copyWith(
      {DateTime? startDate,
      String? setStartDate,
      List<SelectionPopupModel>? repeatDropdown,
      List<DaysItemModel>? daysOfWeek,
      DateTime? endDate,
      String? setEndDate}) {
    return SetDateModel(
        startDate: startDate ?? this.startDate,
        setStartDate: setStartDate ?? this.setStartDate,
        repeatDropdown: repeatDropdown ?? this.repeatDropdown,
        daysOfWeek: daysOfWeek ?? this.daysOfWeek,
        endDate: endDate ?? this.endDate,
        setEndDate: setEndDate ?? this.setEndDate);
  }

  @override
  List<Object?> get props => [
        startDate,
        setStartDate,
        repeatDropdown,
        daysOfWeek,
        endDate,
        setEndDate
      ];
}
