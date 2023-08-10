import 'dart:async';

import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/tip.dart';
import 'package:sqflite/sql.dart';

class TipDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Tip record
  Future<int> createTip(TipModel tip) async {
    final db = await dbProvider.database;
    var result = db.insert(tipsTABLE, tip.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllTips() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(tipsTABLE);
    if (result.isNotEmpty) return result;
    return [];
  }

  Future<List<Map<String, dynamic>>> getTipsByAge(int period) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result =
        await db.query(tipsTABLE, where: 'period = ?', whereArgs: [period]);

    if (result.isNotEmpty) return result;
    return [];
  }

  Future<Map<String, dynamic>?> getTipByID(int tipId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = List.empty();
    result = await db.query(tipsTABLE, where: 'id = ?', whereArgs: [tipId]);

    if (result.isNotEmpty) return result[0];
    return null;
  }

  //Update Tip record
  Future<int> updateTip(TipModel tip) async {
    final db = await dbProvider.database;

    var result = await db
        .update(tipsTABLE, tip.toMap(), where: "id = ?", whereArgs: [tip.id]);

    return result;
  }

  //Delete Tip records
  Future<int> deleteTip(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(tipsTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllTips() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      tipsTABLE,
    );

    return result;
  }
}
