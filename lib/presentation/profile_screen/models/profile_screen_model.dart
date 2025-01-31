import 'package:equatable/equatable.dart';

// THis class defines the properties of the user object and is used to hold data that is passed between the different layers of the application
class ProfileScreenModel extends Equatable{
  ProfileScreenModel();

  ProfileScreenModel copyWith() {
    return ProfileScreenModel();
  }

  @override
  List<Object?> get props => [];
}