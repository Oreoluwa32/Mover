part of 'identification_notifier.dart';

// Represents the state of identification in the app
// ignore for file, must be immutable
class IdentificationState extends Equatable {
  IdentificationState({
    this.ninController,
    this.bvnController,
    this.identificationModelObj,
  });

  final TextEditingController? ninController;
  final TextEditingController? bvnController;
  final IdentificationModel? identificationModelObj;

  @override
  List<Object?> get props => [
        ninController,
        bvnController,
        identificationModelObj,
      ];

  IdentificationState copyWith({
    TextEditingController? ninController,
    TextEditingController? bvnController,
    IdentificationModel? identificationModelObj,
  }) {
    return IdentificationState(
      ninController: ninController ?? this.ninController,
      bvnController: bvnController ?? this.bvnController,
      identificationModelObj:
          identificationModelObj ?? this.identificationModelObj,
    );
  }
}
