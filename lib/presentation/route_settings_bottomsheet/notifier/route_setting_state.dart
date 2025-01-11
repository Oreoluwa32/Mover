part of 'route_setting_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class RouteSettingState extends Equatable {
  RouteSettingState({this.routeSettingModelObj});

  RouteSettingModel? routeSettingModelObj;

  @override
  List<Object?> get props => [routeSettingModelObj];
  RouteSettingState copyWith({RouteSettingModel? routeSettingModelObj}) {
    return RouteSettingState(
        routeSettingModelObj:
            routeSettingModelObj ?? this.routeSettingModelObj);
  }
}
