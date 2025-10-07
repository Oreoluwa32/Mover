part of 'home_notifier.dart';

// Represents the state of the home screen
// ignore: must_be_immutable
class HomeState extends Equatable{
  HomeState({this.homeModelObj});

  HomeModel? homeModelObj;

  @override
  List<Object?> get props => [homeModelObj];
  HomeState copyWith({HomeModel? homeModelObj}) {
    return HomeState(homeModelObj: homeModelObj ?? this.homeModelObj);
  }
}