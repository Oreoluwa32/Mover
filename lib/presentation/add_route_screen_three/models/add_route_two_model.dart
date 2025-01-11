import 'package:equatable/equatable.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import 'add_route_item_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class AddRouteTwoModel extends Equatable {
  AddRouteTwoModel(
      {this.transportMeansList = const [],
      this.serviceDropdown = const [],
      this.maxCapDropdown = const [],
      this.setDate,
      this.date = "\"\"",
      this.setTime,
      this.time = "\"\"",
      this.repeatDropdown = const [],
      this.setTimeBegin,
      this.timeBegin = "\"\"",
      this.setTimeEnd,
      this.timeEnd = "\"\""}) {
    setDate = setDate ?? DateTime.now();
    setTime = setTime ?? DateTime.now();
    setTimeBegin = setTimeBegin ?? DateTime.now();
    setTimeEnd = setTimeEnd ?? DateTime.now();
  }

  List<AddRouteItemModel> transportMeansList;
  List<SelectionPopupModel> serviceDropdown;
  List<SelectionPopupModel> maxCapDropdown;
  DateTime? setDate;
  String date;
  DateTime? setTime;
  String time;
  List<SelectionPopupModel> repeatDropdown;
  DateTime? setTimeBegin;
  String? timeBegin;
  DateTime? setTimeEnd;
  String? timeEnd;

  AddRouteTwoModel copyWith(
      {List<AddRouteItemModel>? transportMeansList,
      List<SelectionPopupModel>? serviceDropdown,
      List<SelectionPopupModel>? maxCapDropdown,
      DateTime? setDate,
      String? date,
      DateTime? setTime,
      String? time,
      List<SelectionPopupModel>? repeatDropdown,
      DateTime? setTimeBegin,
      String? timeBegin,
      DateTime? setTimeEnd,
      String? timeEnd}) {
    return AddRouteTwoModel(
        transportMeansList: transportMeansList ?? this.transportMeansList,
        serviceDropdown: serviceDropdown ?? this.serviceDropdown,
        maxCapDropdown: maxCapDropdown ?? this.maxCapDropdown,
        setDate: setDate ?? this.setDate,
        date: date ?? this.date,
        setTime: setTime ?? this.setTime,
        time: time ?? this.time,
        repeatDropdown: repeatDropdown ?? this.repeatDropdown,
        setTimeBegin: setTimeBegin ?? this.setTimeBegin,
        timeBegin: timeBegin ?? this.timeBegin,
        setTimeEnd: setTimeBegin ?? this.setTimeEnd,
        timeEnd: timeEnd ?? this.timeEnd);
  }

  @override
  List<Object?> get props => [
        transportMeansList,
        serviceDropdown,
        maxCapDropdown,
        setDate,
        date,
        setTime,
        time,
        repeatDropdown,
        setTimeBegin,
        timeBegin,
        setTimeEnd,
        timeEnd,
      ];
}
