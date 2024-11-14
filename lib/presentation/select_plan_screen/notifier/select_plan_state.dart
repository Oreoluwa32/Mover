part of 'select_plan_notifier.dart';

// Represents the state of the select plan screen in the app
// ignore for file, class must be immutable
class SelectPlanState extends Equatable{
  SelectPlanState({this.selectPlanModelObj});

  SelectPlanModel? selectPlanModelObj;

  @override
  List<Object?> get props => [selectPlanModelObj];
  SelectPlanState copyWith({SelectPlanModel? selectPlanModelObj}) {
    return SelectPlanState(
      selectPlanModelObj: selectPlanModelObj ?? this.selectPlanModelObj,
    );
  }
}