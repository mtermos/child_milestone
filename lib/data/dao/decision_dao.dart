import 'dart:async';

import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:sqflite/sqlite_api.dart';

class DecisionDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Decision record
  Future<DaoResponse<bool, int>> createDecision(DecisionModel decision) async {
    final db = await dbProvider.database;
    DaoResponse<bool, int> result = const DaoResponse(false, 0);

    List<Map<String, dynamic>> decisionItem = await db.query(
      decisionsTABLE,
      where: 'milestoneId = ? AND childId = ?',
      whereArgs: [decision.milestoneId, decision.childId],
    );

    if (decisionItem.isEmpty) {
      try {
        var id = await db.insert(decisionsTABLE, decision.toMap());
        result = DaoResponse(true, id);
      } catch (err) {
        if (err is DatabaseException) {
          print('err: ${err}');
          result = DaoResponse(false, err.getResultCode() ?? 0);
        }
      }
    } else {
      decision.id = decisionItem[0]["id"];
      return updateDecision(decision);
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getAllDecisions() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(decisionsTABLE);
    if (result.isNotEmpty) return result;
    return [];
  }

  Future<DaoResponse<List<Map<String, dynamic>>, int>> getDecisionsByAge(
      int weeks, int childId) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = [];

    List<Map<String, dynamic>> milestones = await db.query(
      milestonesTABLE,
      where: 'startingWeek <= ? And endingWeek >= ?',
      whereArgs: [weeks, weeks],
    );

    for (var milestoneMap in milestones) {
      List<Map<String, dynamic>> decisionItem = await db.query(
        decisionsTABLE,
        where: 'childId = ? AND milestoneId = ?',
        whereArgs: [childId, milestoneMap["id"]],
      );
      if (decisionItem.isNotEmpty) {
        result.add(decisionItem[0]);
      }
    }

    return DaoResponse(result.isNotEmpty ? result : [], milestones.length);
  }

  Future<Map<String, dynamic>> getDecisionByChildAndMilestone(
      int childId, int milestoneId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> decisionItem = await db.query(
      decisionsTABLE,
      where: 'childId = ? AND milestoneId = ?',
      whereArgs: [childId, milestoneId],
    );
    return decisionItem.isNotEmpty ? decisionItem[0] : {};
  }

  Future<Map<String, dynamic>?> getDecisionByID(int decisionId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = new List.empty();
    result = await db
        .query(decisionsTABLE, where: 'id = ?', whereArgs: [decisionId]);

    if (result.isNotEmpty) return result[0];
  }

  //Update Decision record
  Future<DaoResponse<bool, int>> updateDecision(DecisionModel decision) async {
    final db = await dbProvider.database;
    DaoResponse<bool, int> result = const DaoResponse(false, 0);

    try {
      var id = await db.update(decisionsTABLE, decision.toMap(),
          where: "id = ?", whereArgs: [decision.id]);
      result = DaoResponse(true, id);
    } catch (err) {
      if (err is DatabaseException) {
        print('err: ${err}');
        result = DaoResponse(false, err.getResultCode() ?? 0);
      }
    }

    return result;
  }

  //Delete Decision records
  Future<int> deleteDecision(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(decisionsTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllDecisions() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      decisionsTABLE,
    );

    return result;
  }
}
