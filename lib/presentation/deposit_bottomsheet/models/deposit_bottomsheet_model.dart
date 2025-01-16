import 'package:equatable/equatable.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app

// ignore for file, class must be immutable
class DepositBottomsheetModel extends Equatable {
  DepositBottomsheetModel({this.enterExpiryDate, this.expiryDate = "\"\""}) {
    enterExpiryDate = enterExpiryDate ?? DateTime.now();
  }

  DateTime? enterExpiryDate;
  String expiryDate;

  DepositBottomsheetModel copyWith(
      {DateTime? enterExpiryDate, String? expiryDate}) {
    return DepositBottomsheetModel(
        enterExpiryDate: enterExpiryDate ?? this.enterExpiryDate,
        expiryDate: expiryDate ?? this.expiryDate);
  }

  @override
  List<Object?> get props => [enterExpiryDate, expiryDate];
}
