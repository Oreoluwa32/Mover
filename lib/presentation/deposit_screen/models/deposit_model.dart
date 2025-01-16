import 'package:equatable/equatable.dart';
import 'deposit_item_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app

// ignore for file, class must be immutable
class DepositModel extends Equatable {
  DepositModel({this.depositItemList = const []});

  List<DepositItemModel> depositItemList;

  DepositModel copyWith({List<DepositItemModel>? depositItemList}) {
    return DepositModel(
        depositItemList: depositItemList ?? this.depositItemList);
  }

  @override
  List<Object?> get props => [depositItemList];
}
