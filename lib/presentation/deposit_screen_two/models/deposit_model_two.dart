import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'deposit_item_two_model.dart';

// This class defines the variables used in the screen and is used to hold data that is passed between different parts of the app
// ignore for file, class must be immutable
class DepositModelTwo extends Equatable {
  DepositModelTwo({this.depositItemTwoList = const []});

  List<DepositItemTwoModel> depositItemTwoList;

  DepositModelTwo copyWith({List<DepositItemTwoModel>? depositItemTwoList}) {
    return DepositModelTwo(
        depositItemTwoList: depositItemTwoList ?? this.depositItemTwoList);
  }

  @override
  List<Object?> get props => [depositItemTwoList];
}
