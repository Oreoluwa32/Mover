part of 'splash_screen_one_notifier.dart';

// Represents the state of the splsh screen in the app
// ignore for file, must be immutable
class SplashScreenOneState extends Equatable{
  SplashScreenOneState({this.splashScreenOneModelObj});

  SplashScreenOneModel? splashScreenOneModelObj;

  @override
  List<Object?> get props => [splashScreenOneModelObj];
  SplashScreenOneState copyWith({SplashScreenOneModel? splashScreenOneModelObj}) {
    return SplashScreenOneState(
      splashScreenOneModelObj: splashScreenOneModelObj ?? this.splashScreenOneModelObj,
    );
  }
}