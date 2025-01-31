part of 'completed_notifier.dart';

// Represents the state of the completed bottom sheet screen
// ignore for file, class must be immutable
class CompletedState extends Equatable{
  CompletedState({this.completedModelObj});

  CompletedModel? completedModelObj;

  @override
  List<Object?> get props => [completedModelObj];
  CompletedState copyWith({
    CompletedModel? completedModelObj
  }) {
    return CompletedState(
      completedModelObj: completedModelObj ?? this.completedModelObj
    );
  }
}