part of 'splash_screen_two_notifier.dart';

// Represents the state of the splsh screen in the app
// ignore for file, must be immutable
class SplashScreenTwoState extends Equatable{
  SplashScreenTwoState({this.splashScreenTwoModelObj});

  SplashScreenTwoModel? splashScreenTwoModelObj;

  @override
  List<Object?> get props => [splashScreenTwoModelObj];
  SplashScreenTwoState copyWith({SplashScreenTwoModel? splashScreenTwoModelObj}) {
    return SplashScreenTwoState(
      splashScreenTwoModelObj: splashScreenTwoModelObj ?? this.splashScreenTwoModelObj,
    );
  }
}