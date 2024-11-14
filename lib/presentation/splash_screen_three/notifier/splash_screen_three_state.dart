part of 'splash_screen_three_notifier.dart';

// Represents the state of the splsh screen in the app
// ignore for file, must be immutable
class SplashScreenThreeState extends Equatable{
  SplashScreenThreeState({this.splashScreenThreeModelObj});

  SplashScreenThreeModel? splashScreenThreeModelObj;

  @override
  List<Object?> get props => [splashScreenThreeModelObj];
  SplashScreenThreeState copyWith({SplashScreenThreeModel? splashScreenThreeModelObj}) {
    return SplashScreenThreeState(
      splashScreenThreeModelObj: splashScreenThreeModelObj ?? this.splashScreenThreeModelObj,
    );
  }
}