import 'package:equatable/equatable.dart';

// This class is used in the screen
// ignore for file, class must be immutable
class DaysItemModel extends Equatable {
  DaysItemModel({this.days, this.isSelected}) {
    days = days ?? "S";
    isSelected = isSelected ?? false;
  }

  String? days;
  bool? isSelected;

  DaysItemModel copyWith({String? days, bool? isSelected}) {
    return DaysItemModel(
        days: days ?? this.days, isSelected: isSelected ?? this.isSelected);
  }

  @override
  List<Object?> get props => [days, isSelected];
}
