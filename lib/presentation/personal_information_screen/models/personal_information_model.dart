import 'package:equatable/equatable.dart';

// This class defines the variables used in the personal info screen and is used to hold data that is passed between different parts of the app
class PersonalInformationModel extends Equatable{
  PersonalInformationModel();

  PersonalInformationModel copyWith() {
    return PersonalInformationModel();
  }

  @override
  List<Object?> get props => [];
}