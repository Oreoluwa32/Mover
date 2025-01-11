part of 'hire_mover_one_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class HireMoverOneState extends Equatable {
  HireMoverOneState({this.hireMoverOneModelObj});

  HireMoverOneModel? hireMoverOneModelObj;

  @override
  List<Object?> get props => [hireMoverOneModelObj];
  HireMoverOneState copyWith({HireMoverOneModel? hireMoverOneModelObj}) {
    return HireMoverOneState(
        hireMoverOneModelObj:
            hireMoverOneModelObj ?? this.hireMoverOneModelObj);
  }
}
