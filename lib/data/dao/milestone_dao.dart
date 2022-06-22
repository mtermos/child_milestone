import 'dart:async';

import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:sqflite/sqlite_api.dart';

class MilestoneDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Milestone record
  Future<int> createMilestone(MilestoneItem milestone) async {
    final db = await dbProvider.database;
    var result = db.insert(milestonesTABLE, milestone.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllMilestones() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(milestonesTABLE);
    return result;
  }

  Future<Map<String, dynamic>?> getMilestoneByID(int milestone_id) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = new List.empty();
    result = await db
        .query(milestonesTABLE, where: 'id = ?', whereArgs: [milestone_id]);

    if (result.isNotEmpty) return result[0];
  }

  Future<List<Map<String, dynamic>>?> getMilestonesByAge(int weeks) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = new List.empty();
    result = await db.query(milestonesTABLE,
        where: 'startingWeek <= ? And endingWeek >= ?',
        whereArgs: [weeks, weeks]);

    if (result.isNotEmpty) return result;
    return [];
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
}
