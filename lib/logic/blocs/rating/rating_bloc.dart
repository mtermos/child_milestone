import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/data/repositories/rating_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository ratingRepository;

  RatingBloc({required this.ratingRepository}) : super(InitialRatingState()) {
    on<AddRatingEvent>(addRating);
    on<GetAllRatingsEvent>(getAllRatings);
    on<DeleteAllRatingsEvent>(deleteAllRatings);
    on<GetRatingEvent>(getRating);
  }

  void addRating(AddRatingEvent event, Emitter<RatingState> emit) async {
    emit(AddingRatingState());
    await ratingRepository.insertRating(event.rating);
    emit(AddedRatingState());
  }

  void getAllRatings(
      GetAllRatingsEvent event, Emitter<RatingState> emit) async {
    emit(AllRatingsLoadingState());
    // await ratingRepository.deleteAllRatings();
    List<RatingModel>? ratings = await ratingRepository.getAllRatings();
    if (ratings != null) {
      emit(AllRatingsLoadedState(ratings));
    } else {
      emit(AllRatingsLoadingErrorState());
    }
  }

  void deleteAllRatings(
      DeleteAllRatingsEvent event, Emitter<RatingState> emit) async {
    emit(DeleteingAllRatingsState());
    await ratingRepository.deleteAllRatings();
    emit(DeletedAllRatingsState());
  }

  void getRating(GetRatingEvent event, Emitter<RatingState> emit) async {
    emit(RatingLoadingState());
    RatingModel? rating = await ratingRepository.getRatingByID(event.ratingId);
    if (rating != null) {
      emit(RatingLoadedState(rating));
    } else {
      emit(RatingLoadingErrorState());
    }
  }
}
