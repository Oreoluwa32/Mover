part of 'schedule_trip_notifier.dart';

// Represents the state of the schedule trip
// ignore for file, class must be immutable
class ScheduleTripState extends Equatable{
  ScheduleTripState({this.scheduleTripModelObj});

  ScheduleTripModel? scheduleTripModelObj;

  @override
  List<Object?> get props => [scheduleTripModelObj];
  ScheduleTripState copyWith({ScheduleTripModel? scheduleTripModelObj}) {
    return ScheduleTripState(
      scheduleTripModelObj: scheduleTripModelObj ?? this.scheduleTripModelObj,
    );
  }
}