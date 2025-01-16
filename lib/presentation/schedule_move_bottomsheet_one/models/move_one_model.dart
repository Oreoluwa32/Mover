import 'package:equatable/equatable.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app

// ignore for file, class must be immutable
class MoveOneModel extends Equatable {
  MoveOneModel(
      {this.selectedDate,
      this.date = "\"\"",
      this.selectedTime,
      this.time = "\"\""}) {
    selectedDate = selectedDate ?? DateTime.now();
    selectedTime = selectedTime ?? DateTime.now();
  }

  DateTime? selectedDate;
  String date;
  DateTime? selectedTime;
  String time;

  MoveOneModel copyWith(
      {DateTime? selectedDate,
      String? date,
      DateTime? selectedTime,
      String? time}) {
    return MoveOneModel(
        selectedDate: selectedDate ?? this.selectedDate,
        date: date ?? this.date,
        selectedTime: selectedTime ?? this.selectedTime,
        time: time ?? this.time);
  }

  @override
  List<Object?> get props => [selectedDate, date, selectedTime, time];
}
