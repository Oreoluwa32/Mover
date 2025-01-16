part of 'move_one_notifier.dart';

// Represents the state of the screen in the app

// ignore for file, class must be immutable
class MoveOneState extends Equatable {
  MoveOneState(
      {this.dateController,
      this.timeController,
      this.setTime,
      this.moveOneModelObj});

  TextEditingController? dateController;
  TextEditingController? timeController;
  TimeOfDay? setTime;
  MoveOneModel? moveOneModelObj;

  @override
  List<Object?> get props => [dateController, timeController, setTime, moveOneModelObj];
  MoveOneState copyWith(
      {TextEditingController? dateController,
      TextEditingController? timeController,
      TimeOfDay? setTime,
      MoveOneModel? moveOneModelObj}) {
    return MoveOneState(
        dateController: dateController ?? this.dateController,
        timeController: timeController ?? this.timeController,
        setTime: setTime ?? this.setTime,
        moveOneModelObj: moveOneModelObj ?? this.moveOneModelObj);
  }
}
