import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

// This class defines the properties of the activity in progress model and is used to hold data that is passed between the different layers of the application
class ActivityInProgressModel extends Equatable{
  ActivityInProgressModel();

  ActivityInProgressModel copyWith() {
    return ActivityInProgressModel();
  }

  @override
  List<Object?> get props => [];
}