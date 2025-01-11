import 'package:equatable/equatable.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
class PaymentModel extends Equatable {
  PaymentModel();

  PaymentModel copyWith() {
    return PaymentModel();
  }

  @override
  List<Object?> get props => [];
}
