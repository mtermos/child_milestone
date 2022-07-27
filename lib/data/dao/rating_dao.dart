import 'dart:async';

import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/rating.dart';
import 'package:sqflite/sqlite_api.dart';

class RatingDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Rating record
  Future<int> createRating(RatingModel rating) async {
    final db = await dbProvider.database;
    // var result = db.insert(ratingsTABLE, rating.toMap());
    DaoResponse<bool, int> result = const DaoResponse(false, 0);

    List<Map<String, dynamic>> ratingItem = await db.query(
      ratingsTABLE,
      where: 'ratingId = ?',
      whereArgs: [rating.ratingId],
    );
    if (ratingItem.isEmpty) {
      try {
        var id = await db.insert(ratingsTABLE, rating.toMap());
        result = DaoResponse(true, id);
      } catch (err) {
        if (err is DatabaseException) {
          result = DaoResponse(false, err.getResultCode() ?? 0);
        }
      }
    } else {
      rating.id = ratingItem[0]["id"];
      return updateRating(rating);
    }

    return result.item2;
  }

  Future<List<Map<String, dynamic>>> getAllRatings() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(ratingsTABLE);
    if (result.isNotEmpty) return result;
    return [];
  }

  Future<List<Map<String, dynamic>>> getRatingsByAge(int period) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result =
        await db.query(ratingsTABLE, where: 'period = ?', whereArgs: [period]);

    if (result.isNotEmpty) return result;
    return [];
  }

  Future<Map<String, dynamic>?> getRatingByID(int ratingId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = new List.empty();
    result =
        await db.query(ratingsTABLE, where: 'id = ?', whereArgs: [ratingId]);

    if (result.isNotEmpty) return result[0];
  }

  //Update Rating record
  Future<int> updateRating(RatingModel rating) async {
    final db = await dbProvider.database;

    var result = await db.update(ratingsTABLE, rating.toMap(),
        where: "id = ?", whereArgs: [rating.id]);

    return result;
  }

  //Delete Rating records
  Future<int> deleteRating(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(ratingsTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllRatings() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      ratingsTABLE,
    );

    return result;
  }
}
