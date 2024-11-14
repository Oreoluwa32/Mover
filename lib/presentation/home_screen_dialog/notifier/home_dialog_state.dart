part of 'home_dialog_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class HomeDialogState extends Equatable{
  HomeDialogState({this.homeDialogModelObj});

  HomeDialogModel? homeDialogModelObj;

  @override
  List<Object?> get props => [homeDialogModelObj];
  HomeDialogState copyWith({HomeDialogModel? homeDialogModelObj}) {
    return HomeDialogState(
      homeDialogModelObj: homeDialogModelObj ?? this.homeDialogModelObj,
    );
  }
}