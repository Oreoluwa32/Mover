import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'completed_item_model.dart';

// This class defines the variables that are used in the ActivityScheduledModel class
// ignore for file, class must be immutable
class ActivityCompletedModel extends Equatable {
  ActivityCompletedModel({
    this.completedItemList = const [],
  });

  List<CompletedItemModel> completedItemList;

  ActivityCompletedModel copyWith({
    List<CompletedItemModel>? completedItemList,
  }) {
    return ActivityCompletedModel(
      completedItemList: completedItemList ?? this.completedItemList,
    );
  }

  @override
  List<Object?> get props => [completedItemList];
}