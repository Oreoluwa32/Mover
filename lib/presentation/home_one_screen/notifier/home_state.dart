part of 'home_notifier.dart';

// Represents the state of the home screen in the app
// ignore for file, class must be immutable
class HomeState extends Equatable{
  HomeState({
    this.isSelectedSwitch = false, 
    this.homeInitialModelObj, 
    this.homeModelObj,
    this.isLive = false,
    this.showLiveNotification = false,
    this.isToggling = false,
    this.highlightRoute = false,
    this.isNavigationActive = false,
    this.routeLocationLat,
    this.routeLocationLng,
    this.routeDestinationLat,
    this.routeDestinationLng,
    this.routeDestinationName,
  });

  bool isSelectedSwitch;
  HomeModel? homeModelObj;
  HomeInitialModel? homeInitialModelObj;
  bool isLive;
  bool showLiveNotification;
  bool isToggling;
  bool highlightRoute;
  bool isNavigationActive;
  double? routeLocationLat;
  double? routeLocationLng;
  double? routeDestinationLat;
  double? routeDestinationLng;
  String? routeDestinationName;

  @override
  List<Object?> get props => [
    isSelectedSwitch, 
    homeModelObj, 
    homeInitialModelObj,
    isLive,
    showLiveNotification,
    isToggling,
    highlightRoute,
    isNavigationActive,
    routeLocationLat,
    routeLocationLng,
    routeDestinationLat,
    routeDestinationLng,
    routeDestinationName,
  ];

  HomeState copyWith({
    bool? isSelectedSwitch,
    HomeModel? homeModelObj,
    HomeInitialModel? homeInitialModelObj,
    bool? isLive,
    bool? showLiveNotification,
    bool? isToggling,
    bool? highlightRoute,
    bool? isNavigationActive,
    double? routeLocationLat,
    double? routeLocationLng,
    double? routeDestinationLat,
    double? routeDestinationLng,
    String? routeDestinationName,
  }) {
    return HomeState(
      isSelectedSwitch: isSelectedSwitch ?? this.isSelectedSwitch,
      homeModelObj: homeModelObj ?? this.homeModelObj,
      homeInitialModelObj: homeInitialModelObj ?? this.homeInitialModelObj,
      isLive: isLive ?? this.isLive,
      showLiveNotification: showLiveNotification ?? this.showLiveNotification,
      isToggling: isToggling ?? this.isToggling,
      highlightRoute: highlightRoute ?? this.highlightRoute,
      isNavigationActive: isNavigationActive ?? this.isNavigationActive,
      routeLocationLat: routeLocationLat ?? this.routeLocationLat,
      routeLocationLng: routeLocationLng ?? this.routeLocationLng,
      routeDestinationLat: routeDestinationLat ?? this.routeDestinationLat,
      routeDestinationLng: routeDestinationLng ?? this.routeDestinationLng,
      routeDestinationName: routeDestinationName ?? this.routeDestinationName,
    );
  }
}