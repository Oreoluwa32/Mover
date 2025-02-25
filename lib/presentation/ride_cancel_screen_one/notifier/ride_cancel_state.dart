part of 'ride_cancel_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class RideCancelState extends Equatable{
  RideCancelState({this.radioGroup = "", this.rideCancelModelObj});

  RideCancelModel? rideCancelModelObj;

  String radioGroup;

  @override
  List<Object?> get props => [radioGroup, rideCancelModelObj];
  RideCancelState copyWith({
    String? radioGroup,
    RideCancelModel? rideCancelModelObj,
  }) {
    return RideCancelState(
      radioGroup: radioGroup ?? this.radioGroup,
      rideCancelModelObj: rideCancelModelObj ?? this.rideCancelModelObj
    );
  }
}