part of 'hire_mover_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class HireMoverState extends Equatable{
  HireMoverState({this.hireMoverModelObj});

  HireMoverModel? hireMoverModelObj;

  @override
  List<Object?> get props => [hireMoverModelObj];
  HireMoverState copyWith({HireMoverModel? hireMoverModelObj}) {
    return HireMoverState(
      hireMoverModelObj: hireMoverModelObj ?? this.hireMoverModelObj
    );
  }
}