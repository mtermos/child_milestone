import 'dart:async';

import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/child_model.dart';

class ChildDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Child records
  Future<int> createChild(ChildModel child) async {
    final db = await dbProvider.database;
    var result = db.insert(childrenTABLE, child.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllChildren() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(childrenTABLE);
    return result;
  }

  Future<Map<String, dynamic>?> getChildByID(String child_id) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = new List.empty();
    result =
        await db.query(childrenTABLE, where: 'child_id = ?', whereArgs: [child_id]);

    if (result.isNotEmpty)
      return result[0];
  }

  //Update Child record
  Future<int> updateChild(ChildModel child) async {
    final db = await dbProvider.database;

    var result = await db.update(childrenTABLE, child.toMap(),
        where: "child_id = ?", whereArgs: [child.child_id]);

    return result;
  }

  //Delete Child records
  Future<int> deleteChild(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(childrenTABLE, where: 'id = ?', whereArgs: [id]);

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
