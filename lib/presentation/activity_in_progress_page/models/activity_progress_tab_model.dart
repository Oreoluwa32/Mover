import 'package:equatable/equatable.dart';
import 'progress_item_model.dart';

// THis class is used in the activity progress tab to hold the data of the activity progress tab
// ignore for file, class must be immutable
class ActivityProgressTabModel extends Equatable{
  ActivityProgressTabModel({
    this.progressList = const [],
  });

  List<ProgressItemModel> progressList;

  ActivityProgressTabModel copyWith({
    List<ProgressItemModel>? progressList
  }) {
    return ActivityProgressTabModel(
      progressList: progressList ?? this.progressList
    );
  }

  @override
  List<Object?> get props => [progressList];
}