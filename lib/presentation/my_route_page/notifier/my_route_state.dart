part of 'my_route_notifier.dart';

// Represents the state of screen in the app
// ignore for file, class must be immutable
class MyRouteState extends Equatable {
  MyRouteState({this.myRouteModelObj});

  MyRouteModel? myRouteModelObj;

  @override
  List<Object?> get props => [myRouteModelObj];
  MyRouteState copyWith({MyRouteModel? myRouteModelObj}) {
    return MyRouteState(
        myRouteModelObj: myRouteModelObj ?? this.myRouteModelObj);
  }
}
