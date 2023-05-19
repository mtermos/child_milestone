import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/data/repositories/rating_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository ratingRepository;

  RatingBloc({required this.ratingRepository}) : super(InitialRatingState()) {
    on<AddRatingsEvent>(addRatings);
    on<GetAllRatingsEvent>(getAllRatings);
    on<DeleteAllRatingsEvent>(deleteAllRatings);
    on<GetRatingEvent>(getRating);
    on<UploadRatingsEvent>(uploadRatings);
  }

  void addRatings(AddRatingsEvent event, Emitter<RatingState> emit) async {
    emit(AddingRatingsState());
    for (RatingModel rating in event.ratings) {
      await ratingRepository.insertRating(rating);
    }
    // updateRatingOnBackend(rating);
    emit(AddedRatingsState());
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

  void uploadRatings(
      UploadRatingsEvent event, Emitter<RatingState> emit) async {
    emit(UploadingRatingsState());
    List<RatingModel> newRatings = (await ratingRepository.getAllRatings())
        .where((element) => !element.uploaded)
        .toList();

    bool noErrors = true;
    if (newRatings.isNotEmpty) {
      for (var rating in newRatings) {
        String? error = await updateRatingOnBackend(rating);
        if (error == null) {
          rating.uploaded = true;
          await ratingRepository.updateRating(rating);
        } else {
          noErrors = false;
          emit(ErrorUploadingRatingsState(error: error));
        }
      }
    }
    if (noErrors) emit(UploadedRatingsState());
  }

  Future<String?> updateRatingOnBackend(RatingModel ratingModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SharedPrefKeys.accessToken);
    String? userID = prefs.getString(SharedPrefKeys.userID);
    if (token != null) {
      try {
        final response = await http.put(
          Uri.parse(Urls.backendUrl + Urls.userUpdateUrl),
          headers: {
            "Authorization": "Bearer " + token,
          },
          body: {
            "id": ratingModel.ratingId,
            "rating": ratingModel.rating,
            "parent_id": userID,
          },
        );
        // print('response.body: ${response.body}');
        if (response.statusCode == 200) {
          return null;
        } else {
          return "response not 200";
        }
      } catch (e) {
        return "connection failed";
      }
    }
    return "token not available";
  }
}
