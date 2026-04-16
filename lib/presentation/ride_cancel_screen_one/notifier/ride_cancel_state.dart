part of 'ride_cancel_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class RideCancelState extends Equatable{
  RideCancelState({
    this.radioGroup = "",
    this.otherReason = "",
    this.rideCancelModelObj,
  });

  RideCancelModel? rideCancelModelObj;

  String radioGroup;
  String otherReason;

  @override
  List<Object?> get props => [radioGroup, otherReason, rideCancelModelObj];
  RideCancelState copyWith({
    String? radioGroup,
    String? otherReason,
    RideCancelModel? rideCancelModelObj,
  }) {
    return RideCancelState(
      radioGroup: radioGroup ?? this.radioGroup,
      otherReason: otherReason ?? this.otherReason,
      rideCancelModelObj: rideCancelModelObj ?? this.rideCancelModelObj
    );
  }
}
