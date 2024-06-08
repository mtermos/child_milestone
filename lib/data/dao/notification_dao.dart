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

  Future<List<Map<String, dynamic>>> getNotificationsBtwDates(
      DateTime startDate, DateTime endDate) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];
    result = await db.query(notificationsTABLE,
        where: 'issuedAt >= ? AND issuedAt <= ?',
        whereArgs: [
          startDate.millisecondsSinceEpoch,
          endDate..millisecondsSinceEpoch
        ]);

    return result;
  }

  Future<List<Map<String, dynamic>>> getNotificationsByChildIdAndPeriod(
      int childId, int period) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];
    result = await db.query(notificationsTABLE,
        where: 'childId = ? AND period = ?', whereArgs: [childId, period]);

    return result;
  }

  Future<List<Map<String, dynamic>>> getNotificationsByChildIdAndMonth(
      int childId, int month) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];

    List<Map<String, dynamic>> result2 =
        await db.rawQuery('PRAGMA table_info($notificationsTABLE);');

    // Check if the column exists in the result
    for (var column in result2) {
      if (column['name'] == "endingAge") {
        result = await db.query(notificationsTABLE,
            where: 'childId = ? AND endingAge <= ?',
            whereArgs: [childId, month]);
      }
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getNotificationsByChildId(
      int childId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];
    result = await db
        .query(notificationsTABLE, where: 'childId = ?', whereArgs: [childId]);

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

  //We are not going to use this in the demo
  Future deleteAllNotificationsByChildId(int childId) async {
    final db = await dbProvider.database;
    var result = await db
        .delete(notificationsTABLE, where: 'childId = ?', whereArgs: [childId]);

    return result;
  }
}
