part of 'hire_mover_two_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immuatble
class HireMoverTwoState extends Equatable {
  HireMoverTwoState({this.hireMoverTwoModelObj});

  HireMoverTwoModel? hireMoverTwoModelObj;

  @override
  List<Object?> get props => [hireMoverTwoModelObj];
  HireMoverTwoState copyWith({HireMoverTwoModel? hireMoverTwoModelObj}) {
    return HireMoverTwoState(
        hireMoverTwoModelObj:
            hireMoverTwoModelObj ?? this.hireMoverTwoModelObj);
  }
}
