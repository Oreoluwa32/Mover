part of 'home_notifier.dart';

// Represents the state of the home screen in the app
// ignore for file, class must be immutable
class HomeState extends Equatable{
  HomeState({this.isSelectedSwitch = false, this.homeInitialModelObj, this.homeModelObj});

  bool isSelectedSwitch;
  HomeModel? homeModelObj;
  HomeInitialModel? homeInitialModelObj;

  @override
  List<Object?> get props => [isSelectedSwitch, homeModelObj, homeInitialModelObj];
  HomeState copyWith({
    bool? isSelectedSwitch,
    HomeModel? homeModelObj,
    HomeInitialModel? homeInitialModelObj,
  }) {
    return HomeState(
      isSelectedSwitch: isSelectedSwitch ?? this.isSelectedSwitch,
      homeModelObj: homeModelObj ?? this.homeModelObj,
      homeInitialModelObj: homeInitialModelObj ?? this.homeInitialModelObj,
    );
  }
}