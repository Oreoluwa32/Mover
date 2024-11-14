part of 'no_mover_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class NoMoverState extends Equatable{
  NoMoverState({this.noMoverModelObj});

  NoMoverModel? noMoverModelObj;

  @override
  List<Object?> get props => [noMoverModelObj];
  NoMoverState copyWith({NoMoverModel? noMoverModelObj}) {
    return NoMoverState(
      noMoverModelObj: noMoverModelObj ?? this.noMoverModelObj,
    );
  }
}