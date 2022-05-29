import 'dart:async';

import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/child_model.dart';

class ChildDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Child records
  Future<int> createChild(ChildModel child) async {
    final db = await dbProvider.database;
    var result = db.insert(childsTABLE, child.toMap());
    return result;
  }

  //Get All Child items
  //Searches if query string was passed
  Future<List<ChildModel>> getChilds(
      {List<String>? columns, String? query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = new List.empty();
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(childsTABLE,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(childsTABLE, columns: columns);
    }

    List<ChildModel> childs = result.isNotEmpty
        ? result.map((item) => ChildModel.fromMap(item)).toList()
        : [];
    return childs;
  }

  //Update Child record
  Future<int> updateChild(ChildModel child) async {
    final db = await dbProvider.database;

    var result = await db.update(childsTABLE, child.toMap(),
        where: "child_id = ?", whereArgs: [child.child_id]);

    return result;
  }

  //Delete Child records
  Future<int> deleteChild(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(childsTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllChilds() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      childsTABLE,
    );

    return result;
  }
}
