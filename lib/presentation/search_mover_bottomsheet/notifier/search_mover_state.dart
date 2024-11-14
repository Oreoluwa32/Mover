part of 'search_mover_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class SearchMoverState extends Equatable{
  SearchMoverState({
    this.radioGroup = "", this.searchMoverModelObj
  });

  SearchMoverModel? searchMoverModelObj;
  String radioGroup;

  @override
  List<Object?> get props => [radioGroup, searchMoverModelObj];
  SearchMoverState copyWith({
    String? radioGroup,
    SearchMoverModel? searchMoverModelObj,
  }) {
    return SearchMoverState(
      radioGroup: radioGroup ?? this.radioGroup,
      searchMoverModelObj: searchMoverModelObj ?? this.searchMoverModelObj,
    );
  }
}