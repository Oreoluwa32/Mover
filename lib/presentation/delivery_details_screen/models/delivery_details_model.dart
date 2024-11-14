import 'package:equatable/equatable.dart';

// This class defines the variable used in the delivery details screen and is used to hold data that is passed between different parts of the app
class DeliveryDetailsModel extends Equatable{
  DeliveryDetailsModel();

  DeliveryDetailsModel copyWith() {
    return DeliveryDetailsModel();
  }

  @override
  List<Object?> get props => [];
}