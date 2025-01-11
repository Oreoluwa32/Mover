import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import 'add_route_one_item_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class AddRouteOneModel extends Equatable {
  AddRouteOneModel({
    this.transportMeansList = const [],
    this.serviceTypeDropdown = const [],
    this.setTime,
    this.time = "\"\"",
  }) {
    setTime = setTime ?? DateTime.now();
  }

  List<AddRouteOneItemModel> transportMeansList;
  List<SelectionPopupModel> serviceTypeDropdown;
  DateTime? setTime;
  String time;

  AddRouteOneModel copyWith(
      {List<AddRouteOneItemModel>? transportMeansList,
      List<SelectionPopupModel>? serviceTypeDropdown,
      DateTime? setTime,
      String? time}) {
    return AddRouteOneModel(
      transportMeansList: transportMeansList ?? this.transportMeansList,
      serviceTypeDropdown: serviceTypeDropdown ?? this.serviceTypeDropdown,
      setTime: setTime ?? this.setTime,
      time: time ?? this.time,
    );
  }

  @override
  List<Object?> get props =>
      [transportMeansList, serviceTypeDropdown, setTime, time];
}
