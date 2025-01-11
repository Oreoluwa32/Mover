part of 'payment_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class PaymentState extends Equatable {
  PaymentState({this.paymentModelObj});

  PaymentModel? paymentModelObj;

  @override
  List<Object?> get props => [paymentModelObj];
  PaymentState copyWith({PaymentModel? paymentModelObj}) {
    return PaymentState(
        paymentModelObj: paymentModelObj ?? this.paymentModelObj);
  }
}
