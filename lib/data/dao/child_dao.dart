import 'dart:async';

import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:sqflite/sqlite_api.dart';

class ChildDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Child records
  Future<DaoResponse<bool, int>> createChild(ChildModel child) async {
    final db = await dbProvider.database;
    DaoResponse<bool, int> result;
    try {
      var id = await db.insert(childrenTABLE, child.toMap());
      result = DaoResponse(true, id);
    } catch (err) {
      if (err is DatabaseException) {
        result = DaoResponse(false, err.getResultCode() ?? 0);
      }
      result = const DaoResponse(false, -1);
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllChildren() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(childrenTABLE);
    return result;
  }

  Future<Map<String, dynamic>?> getChildByID(int id) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    result = await db.query(childrenTABLE, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) return result[0];
    return null;
  }

  //Update Child record
  Future<DaoResponse<bool, int>> updateChild(ChildModel child) async {
    final db = await dbProvider.database;
    DaoResponse<bool, int> result;

    try {
      var id = await db.update(childrenTABLE, child.toMap(),
          where: "id = ?", whereArgs: [child.id]);
      result = DaoResponse(true, id);
    } catch (err) {
      if (err is DatabaseException) {
        result = DaoResponse(false, err.getResultCode() ?? 0);
      }
      result = const DaoResponse(false, -1);
    }

    return result;
  }

  //Delete Child records
  Future<int> deleteChild(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(childrenTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllChildren() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      childrenTABLE,
    );

    return result;
  }
}
