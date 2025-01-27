import 'dart:async';

import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:sqflite/sql.dart';

class MilestoneDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Milestone record
  Future<int> createMilestone(MilestoneItem milestone) async {
    final db = await dbProvider.database;
    var result = db.insert(milestonesTABLE, milestone.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllMilestones() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(milestonesTABLE);
    return result;
  }

  Future<Map<String, dynamic>?> getMilestoneByID(int milestoneId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];
    result = await db
        .query(milestonesTABLE, where: 'id = ?', whereArgs: [milestoneId]);

    if (result.isNotEmpty) return result[0];
    return null;
  }

  Future<List<Map<String, dynamic>>?> getMilestonesByAge(int period) async {
    final db = await dbProvider.database;

    return db.query(milestonesTABLE, where: 'period = ?', whereArgs: [period]);
  }

  //Update Milestone record
  Future<int> updateMilestone(MilestoneItem milestone) async {
    final db = await dbProvider.database;

    var result = await db.update(milestonesTABLE, milestone.toMap(),
        where: "id = ?", whereArgs: [milestone.id]);

    return result;
  }

  //Delete Milestone records
  Future<int> deleteMilestone(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(milestonesTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllMilestones() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      milestonesTABLE,
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> getMilestonesUntilPeriod(
      int period) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db
        .query(milestonesTABLE, where: 'period < ?', whereArgs: [period + 1]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getMilestonesUntilMonth(int month) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db
        .query(milestonesTABLE, where: 'endingAge < ?', whereArgs: [month]);
    return result;
  }
}
