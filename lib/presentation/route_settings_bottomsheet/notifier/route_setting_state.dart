part of 'route_setting_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class RouteSettingState extends Equatable {
  final double distance;

  RouteSettingState({this.routeSettingModelObj, this.distance = 1.0});

  RouteSettingModel? routeSettingModelObj;

  @override
  List<Object?> get props => [distance, routeSettingModelObj];
  RouteSettingState copyWith({double? distance,
    RouteSettingModel? routeSettingModelObj}) {
    return RouteSettingState(
        distance: distance ?? this.distance,
        routeSettingModelObj:
            routeSettingModelObj ?? this.routeSettingModelObj);
  }
}
