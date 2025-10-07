import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';

// This class defines the variables used in the home screen and is used to hold data that is passed between different parts of the app
class HomeModel extends Equatable{
  HomeModel();

  HomeModel copyWith() {
    return HomeModel();
  }

  @override
  List<Object?> get props => [];
} 