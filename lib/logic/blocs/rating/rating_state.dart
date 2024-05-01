part of 'rating_bloc.dart';

@immutable
abstract class RatingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialRatingState extends RatingState {}

class AddingRatingsState extends RatingState {}

class AddedRatingsState extends RatingState {}

class RatingLoadingState extends RatingState {}

class RatingLoadingErrorState extends RatingState {}

class RatingLoadedState extends RatingState {
  final RatingModel rating;

  RatingLoadedState(this.rating);

  @override
  List<Object?> get props => [rating];
}

class AllRatingsLoadingState extends RatingState {}

class AllRatingsLoadingErrorState extends RatingState {}

class AllRatingsLoadedState extends RatingState {
  final List<RatingModel> ratings;

  AllRatingsLoadedState(this.ratings);

  @override
  List<Object?> get props => [ratings];
}

class DeleteingAllRatingsState extends RatingState {}

class DeletedAllRatingsState extends RatingState {}

class RatingErrorState extends RatingState {
  final String error;

  RatingErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class UploadingRatingsState extends RatingState {}

class ErrorUploadingRatingsState extends RatingState {
  final String error;
  ErrorUploadingRatingsState({
    required this.error,
  });
}

class UploadedRatingsState extends RatingState {}
