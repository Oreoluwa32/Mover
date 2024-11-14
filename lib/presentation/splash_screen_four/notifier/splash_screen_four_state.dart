part of 'splash_screen_four_notifier.dart';

// Represents the state of the splsh screen in the app
// ignore for file, must be immutable
class SplashScreenFourState extends Equatable{
  SplashScreenFourState({this.splashScreenFourModelObj});

  SplashScreenFourModels? splashScreenFourModelObj;

  @override
  List<Object?> get props => [splashScreenFourModelObj];
  SplashScreenFourState copyWith({SplashScreenFourModels? splashScreenFourModelObj}) {
    return SplashScreenFourState(
      splashScreenFourModelObj: splashScreenFourModelObj ?? this.splashScreenFourModelObj,
    );
  }
}