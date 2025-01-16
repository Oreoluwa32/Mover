part of 'move_notifier.dart';

// Represents the state of the screen in the app

// ignore for file, class must be immutable
class MoveState extends Equatable {
  MoveState({this.moveModelObj});

  MoveModel? moveModelObj;

  @override
  List<Object?> get props => [moveModelObj];
  MoveState copyWith({MoveModel? moveModelObj}) {
    return MoveState(moveModelObj: moveModelObj ?? this.moveModelObj);
  }
}
