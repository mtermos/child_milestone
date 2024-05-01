// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'rating_bloc.dart';

@immutable
abstract class RatingEvent extends Equatable {
  const RatingEvent();
  @override
  List<Object> get props => [];
}

class AddRatingsEvent extends RatingEvent {
  final List<RatingModel> ratings;

  const AddRatingsEvent({
    required this.ratings,
  });
}

class GetAllRatingsEvent extends RatingEvent {}

class DeleteAllRatingsEvent extends RatingEvent {}

class GetRatingEvent extends RatingEvent {
  final int ratingId;
  const GetRatingEvent({required this.ratingId});
}

class UploadRatingsEvent extends RatingEvent {
  final AppLocalizations appLocalizations;
  const UploadRatingsEvent({
    required this.appLocalizations,
  });
}
