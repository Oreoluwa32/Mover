part of 'rating_notifier.dart';

// Represents the state of the screen in the app
// ignore for file, class must be immutable
class RatingState extends Equatable{
  RatingState({this.ratingModelObj});

  RatingModel? ratingModelObj;

  @override
  List<Object?> get props => [ratingModelObj];
  RatingState copyWith({
    RatingModel? ratingModelObj,
  }) {
    return RatingState(
      ratingModelObj: ratingModelObj ?? this.ratingModelObj
    );
  }
}