part of 'save_route_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immtable
class SaveRouteState extends Equatable {
  SaveRouteState({this.textController, this.saveRouteModelObj});

  TextEditingController? textController;

  SaveRouteModel? saveRouteModelObj;

  @override
  List<Object?> get props => [textController, saveRouteModelObj];
  SaveRouteState copyWith(
      {TextEditingController? textController,
      SaveRouteModel? saveRouteModelObj}) {
    return SaveRouteState(
        textController: textController ?? this.textController,
        saveRouteModelObj: saveRouteModelObj ?? this.saveRouteModelObj);
  }
}
