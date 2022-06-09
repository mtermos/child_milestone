import 'package:child_milestone/data/models/notification.dart';

class NotificationRepository {
  final notificationDao;

  NotificationRepository(this.notificationDao);

  Future getAllNotifications() async {
    List<Map<String, dynamic>> result =
        await notificationDao.getAllNotifications();

    return result.isNotEmpty
        ? result.map((item) => NotificationModel.fromMap(item)).toList()
        : null;
  }

  Future insertNotification(NotificationModel notification) =>
      notificationDao.createNotification(notification);

  Future updateNotification(NotificationModel notification) =>
      notificationDao.updateNotification(notification);

  Future deleteNotificationById(int id) =>
      notificationDao.deleteNotification(id);

  Future deleteAllNotifications() => notificationDao.deleteAllNotifications();

  Future<NotificationModel?> getNotificationByID(int notification_id) async {
    Map<String, dynamic>? result =
        await notificationDao.getNotificationByID(notification_id);
    if (result != null) {
      NotificationModel notification = NotificationModel.fromMap(result);
      return notification;
    }
  }
}
