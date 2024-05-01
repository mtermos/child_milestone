import 'dart:convert';

import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/data/repositories/rating_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:child_milestone/logic/shared/ratingToTextMap.dart';

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
      String? error = await updateRatingsOnBackend(event.appLocalizations);
      if (error == null) {
        for (var rating in newRatings) {
          rating.uploaded = true;
          await ratingRepository.updateRating(rating);
        }
      } else {
        noErrors = false;
        emit(ErrorUploadingRatingsState(error: error));
      }
    }
    if (noErrors) emit(UploadedRatingsState());
  }

  Future<String?> updateRatingsOnBackend(
      AppLocalizations appLocalizations) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SharedPrefKeys.accessToken);
    String? userID = prefs.getString(SharedPrefKeys.userID);
    // print('USERID: ${userID}');

    if (token != null && userID != null) {
      try {
        // Map<String, dynamic> data = {};
        // data["rating"] = ;
        Object body = {
          "id": userID,
          // "data": {"rating": json.encode(await ratingsToJSON(appLocalizations))}
          // "data": jsonEncode({'rating': await ratingsToJSON(appLocalizations)}),
          "data": {"rating": await ratingsToJSON(appLocalizations)},
        };
        // print('BODY: ${json.encode(body)}');
        final response = await http.patch(
          Uri.parse(Urls.backendUrl + Urls.userUpdateUrl),
          headers: {
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json",
          },
          body: json.encode(body),
          // body: body,
        );
        // print('updateRatingsOnBackend.response: ${response}');
        // print('updateRatingsOnBackend.response.body: ${response.body}');
        if (response.statusCode == 200) {
          return null;
        } else {
          print('updateRatingOnBackend.response: response not 200');
          return "response not 200";
        }
      } catch (e) {
        print('updateRatingOnBackend.e: ${e}');
        return "connection failed";
      }
    }
    print('updateRatingOnBackend.error: token not available');
    return "token not available";
  }

  Future<List> ratingsToJSON(AppLocalizations appLocalizations) async {
    List<RatingModel> ratings = await ratingRepository.getAllRatings();
    // List<RatingModel> ratings = await ratingRepository.getAllRatings();

    List data = [];

    for (var rating in ratings) {
      Map<String, String> texts = ratingToTextMap(rating, appLocalizations);
      // if (rating)
      data.add({
        'ratingId': rating.ratingId,
        'question': texts["question"],
        'choice': texts["choice"],
        'additionalText': texts["additionalText"],
        'takenAt': rating.takenAt.millisecondsSinceEpoch,
      });
    }
    // print('RATING: ${ratings.last}');
    // print('ratingsToJSON.DATA: ${data}');
    return data;
  }
}
