import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import 'add_route_one_item_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class AddRouteOneModel extends Equatable{
  AddRouteOneModel({
    this.transportMeansList = const [],
    this.serviceTypeDropdown = const [],
    this.departureDropdown = const []
  });

  List<AddRouteOneItemModel> transportMeansList;
  List<SelectionPopupModel> serviceTypeDropdown;
  List<SelectionPopupModel> departureDropdown;

  AddRouteOneModel copyWith({
    List<AddRouteOneItemModel>? transportMeansList,
    List<SelectionPopupModel>? serviceTypeDropdown,
    List<SelectionPopupModel>? departureDropdown,
  }) {
    return AddRouteOneModel(
      transportMeansList: transportMeansList ?? this.transportMeansList,
      serviceTypeDropdown: serviceTypeDropdown ?? this.serviceTypeDropdown,
      departureDropdown: departureDropdown ?? this.departureDropdown
    );
  }

  @override
  List<Object?> get props => [transportMeansList, serviceTypeDropdown, departureDropdown];
}