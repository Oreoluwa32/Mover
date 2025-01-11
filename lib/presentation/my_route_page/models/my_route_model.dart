import 'package:equatable/equatable.dart';
import 'package:new_project/presentation/my_route_page/widgets/savedroute_item_widget.dart';
import 'saved_route_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class MyRouteModel extends Equatable {
  MyRouteModel({this.savedrouteItemList = const []});

  List<SavedRouteModel> savedrouteItemList;

  MyRouteModel copyWith({List<SavedRouteModel>? savedrouteItemList}) {
    return MyRouteModel(
        savedrouteItemList: savedrouteItemList ?? this.savedrouteItemList);
  }

  @override
  List<Object?> get props => [savedrouteItemList];
}
