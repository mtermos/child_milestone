import 'dart:async';

import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:sqflite/sqlite_api.dart';

class NotificationDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Decision record
  Future<DaoResponse<bool, int>> createNotification(
      Map<String, dynamic> notification) async {
    final db = await dbProvider.database;
    DaoResponse<bool, int> result = const DaoResponse(false, 0);

    try {
      var id = await db.insert(notificationsTABLE, notification);
      result = DaoResponse(true, id);
    } catch (err) {
      if (err is DatabaseException) {
        print('err: ${err}');
        result = DaoResponse(false, err.getResultCode() ?? 0);
      }
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(notificationsTABLE);
    return result;
  }

  Future<Map<String, dynamic>?> getNotificationByID(int notificationId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];
    result = await db.query(notificationsTABLE,
        where: 'id = ?', whereArgs: [notificationId]);

    if (result.isNotEmpty) return result[0];
    return null;
  }

  //Update Notification record
  Future<int> updateNotification(Map<String, dynamic> notification) async {
    final db = await dbProvider.database;

    var result = await db.update(notificationsTABLE, notification,
        where: "id = ?", whereArgs: [notification["id"]]);

    return result;
  }

  //Delete Notification records
  Future<int> deleteNotification(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(notificationsTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllNotifications() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      notificationsTABLE,
    );

    return result;
  }
}
