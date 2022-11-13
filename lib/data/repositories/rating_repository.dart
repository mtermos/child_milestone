import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/logic/shared/functions.dart';

class RatingRepository {
  final ratingDao;

  RatingRepository(this.ratingDao);

  Future getAllRatings() async {
    List<Map<String, dynamic>> result = await ratingDao.getAllRatings();

    return result.isNotEmpty
        ? result.map((item) => RatingModel.fromMap(item)).toList()
        : List<RatingModel>.empty();
  }

  Future insertRating(RatingModel rating) => ratingDao.createRating(rating);

  Future updateRating(RatingModel rating) => ratingDao.updateRating(rating);

  Future deleteRatingById(int id) => ratingDao.deleteRating(id);

  Future deleteAllRatings() => ratingDao.deleteAllRatings();

  Future<RatingModel?> getRatingByID(int ratingId) async {
    Map<String, dynamic>? result = await ratingDao.getRatingByID(ratingId);
    if (result != null) {
      RatingModel rating = RatingModel.fromMap(result);
      return rating;
    }
    return null;
  }

  Future<List<RatingModel>?> getRatingsByAge(DateTime dateOfBirth) async {
    int period = periodCalculator(dateOfBirth).id;

    List<Map<String, dynamic>> result = await ratingDao.getRatingsByAge(period);

    return result.map((item) => RatingModel.fromMap(item)).toList();
  }
}
