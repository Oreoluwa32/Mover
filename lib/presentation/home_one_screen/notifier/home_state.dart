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
    this.pendingTaskType,
    this.pendingTaskData,
    this.isLoadingPendingTask = false,
    this.isSearchingNearbyMovers = false,
    this.nearbyMoverSearchType,
    this.nearbyMoverSearchData,
    this.nearbyMoverSearchEndsAt,
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
  String? pendingTaskType;
  Map<String, dynamic>? pendingTaskData;
  bool isLoadingPendingTask;
  bool isSearchingNearbyMovers;
  String? nearbyMoverSearchType;
  Map<String, dynamic>? nearbyMoverSearchData;
  DateTime? nearbyMoverSearchEndsAt;

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
    pendingTaskType,
    pendingTaskData,
    isLoadingPendingTask,
    isSearchingNearbyMovers,
    nearbyMoverSearchType,
    nearbyMoverSearchData,
    nearbyMoverSearchEndsAt,
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
    String? pendingTaskType,
    Map<String, dynamic>? pendingTaskData,
    bool? isLoadingPendingTask,
    bool? isSearchingNearbyMovers,
    String? nearbyMoverSearchType,
    Map<String, dynamic>? nearbyMoverSearchData,
    DateTime? nearbyMoverSearchEndsAt,
    bool clearPendingTask = false,
    bool clearNearbyMoverSearch = false,
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
      pendingTaskType: clearPendingTask ? null : (pendingTaskType ?? this.pendingTaskType),
      pendingTaskData: clearPendingTask ? null : (pendingTaskData ?? this.pendingTaskData),
      isLoadingPendingTask: isLoadingPendingTask ?? this.isLoadingPendingTask,
      isSearchingNearbyMovers:
          isSearchingNearbyMovers ?? this.isSearchingNearbyMovers,
      nearbyMoverSearchType: clearNearbyMoverSearch
          ? null
          : (nearbyMoverSearchType ?? this.nearbyMoverSearchType),
      nearbyMoverSearchData: clearNearbyMoverSearch
          ? null
          : (nearbyMoverSearchData ?? this.nearbyMoverSearchData),
      nearbyMoverSearchEndsAt: clearNearbyMoverSearch
          ? null
          : (nearbyMoverSearchEndsAt ?? this.nearbyMoverSearchEndsAt),
    );
  }
}
