import 'dart:async';

import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:sqflite/sqlite_api.dart';

class LogDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Decision record
  Future<DaoResponse<bool, int>> createLog(Map<String, dynamic> log) async {
    final db = await dbProvider.database;
    DaoResponse<bool, int> result = const DaoResponse(false, 0);

    try {
      var id = await db.insert(logsTABLE, log);
      result = DaoResponse(true, id);
    } catch (err) {
      if (err is DatabaseException) {
        result = DaoResponse(false, err.getResultCode() ?? 0);
      }
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getAllLogs() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(logsTABLE);
    return result;
  }

  Future<List<Map<String, dynamic>>> getLogsBtwDates(
      DateTime startDate, DateTime endDate) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];
    result = await db.query(logsTABLE,
        where: 'takenAt >= ? AND takenAt <= ?',
        whereArgs: [
          startDate.millisecondsSinceEpoch,
          endDate..millisecondsSinceEpoch
        ]);

    return result;
  }

  Future<Map<String, dynamic>?> getLogByID(int logId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];
    result = await db.query(logsTABLE, where: 'id = ?', whereArgs: [logId]);

    if (result.isNotEmpty) return result[0];
    return null;
  }

  //Update Log record
  Future<int> updateLog(Map<String, dynamic> log) async {
    final db = await dbProvider.database;

    var result = await db
        .update(logsTABLE, log, where: "id = ?", whereArgs: [log["id"]]);

    return result;
  }

  //Delete Log records
  Future<int> deleteLog(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(logsTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllLogs() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      logsTABLE,
    );

    return result;
  }
}
