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
  });

  bool isSelectedSwitch;
  HomeModel? homeModelObj;
  HomeInitialModel? homeInitialModelObj;
  bool isLive;
  bool showLiveNotification;
  bool isToggling;

  @override
  List<Object?> get props => [
    isSelectedSwitch, 
    homeModelObj, 
    homeInitialModelObj,
    isLive,
    showLiveNotification,
    isToggling,
  ];

  HomeState copyWith({
    bool? isSelectedSwitch,
    HomeModel? homeModelObj,
    HomeInitialModel? homeInitialModelObj,
    bool? isLive,
    bool? showLiveNotification,
    bool? isToggling,
  }) {
    return HomeState(
      isSelectedSwitch: isSelectedSwitch ?? this.isSelectedSwitch,
      homeModelObj: homeModelObj ?? this.homeModelObj,
      homeInitialModelObj: homeInitialModelObj ?? this.homeInitialModelObj,
      isLive: isLive ?? this.isLive,
      showLiveNotification: showLiveNotification ?? this.showLiveNotification,
      isToggling: isToggling ?? this.isToggling,
    );
  }
}