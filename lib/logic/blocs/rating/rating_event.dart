// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'rating_bloc.dart';

@immutable
abstract class RatingEvent extends Equatable {
  const RatingEvent();
  @override
  List<Object> get props => [];
}

class AddRatingEvent extends RatingEvent {
  final RatingModel rating;

  const AddRatingEvent({
    required this.rating,
  });
}

class GetAllRatingsEvent extends RatingEvent {}

class DeleteAllRatingsEvent extends RatingEvent {}

class GetRatingEvent extends RatingEvent {
  final int ratingId;
  const GetRatingEvent({required this.ratingId});
}
