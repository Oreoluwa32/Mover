import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/ride_sharing_details_model.dart';
part 'ride_sharing_details_state.dart';

final rideSharingDetailsNotifier = StateNotifierProvider.autoDispose<
    RideSharingDetailsNotifier, RideSharingDetailsState>(
  (ref) => RideSharingDetailsNotifier(RideSharingDetailsState(
    selectedDropDownValue: SelectionPopupModel(title: ''),
    destination: "",
    rideSharingDetailsModelObj: RideSharingDetailsModel(dropdownItemList: [
      SelectionPopupModel(id: 1, title: "1 passenger", isSelected: true),
      SelectionPopupModel(
        id: 2,
        title: "2 passengers",
      ),
      SelectionPopupModel(
        id: 3,
        title: "3 passengers",
      )
    ]),
  )),
);

// A notifier that manages the state of the screen according to the event that is dispatched to it
class RideSharingDetailsNotifier
    extends StateNotifier<RideSharingDetailsState> {
  RideSharingDetailsNotifier(RideSharingDetailsState state) : super(state);

  void updateDestination(String value) {
    state = state.copyWith(destination: value);
  }
}
