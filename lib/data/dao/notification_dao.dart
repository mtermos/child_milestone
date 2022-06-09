import 'dart:async';

import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/notification.dart';

class NotificationDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Notification record
  Future<int> createNotification(NotificationModel notification) async {
    final db = await dbProvider.database;
    var result = db.insert(notificationsTABLE, notification.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(notificationsTABLE);
    return result;
  }

  Future<Map<String, dynamic>?> getNotificationByID(int notification_id) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = new List.empty();
    result =
        await db.query(notificationsTABLE, where: 'id = ?', whereArgs: [notification_id]);

    if (result.isNotEmpty)
      return result[0];
  }

  //Update Notification record
  Future<int> updateNotification(NotificationModel notification) async {
    final db = await dbProvider.database;

    var result = await db.update(notificationsTABLE, notification.toMap(),
        where: "id = ?", whereArgs: [notification.id]);

    return result;
  }

  //Delete Notification records
  Future<int> deleteNotification(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(notificationsTABLE, where: 'id = ?', whereArgs: [id]);

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
