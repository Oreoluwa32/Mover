part of 'share_ride_payment_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class ShareRidePaymentState extends Equatable {
  ShareRidePaymentState({this.shareRidePaymentModelObj});

  ShareRidePaymentModel? shareRidePaymentModelObj;

  @override
  List<Object?> get props => [shareRidePaymentModelObj];
  ShareRidePaymentState copyWith({
    ShareRidePaymentModel? shareRidePaymentModelObj
  }) {
    return ShareRidePaymentState(
      shareRidePaymentModelObj: shareRidePaymentModelObj ?? this.shareRidePaymentModelObj
    );
  }
}
