import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/notification.dart';

class NotificationRepository {
  final notificationDao;
  final childDao;

  NotificationRepository(this.notificationDao, this.childDao);

  Future getAllNotifications() async {
    List<Map<String, dynamic>> result =
        await notificationDao.getAllNotifications();

    return result.isNotEmpty
        ? result.map((item) => NotificationModel.fromMap(item)).toList()
        : null;
  }

  Future<List<NotificationWithChild>?> getAllNotificationsWithChildren() async {
    List<Map<String, dynamic>> notifications =
        await notificationDao.getAllNotifications();

    if (notifications.isEmpty) return null;

    List<Map<String, dynamic>> children = await childDao.getAllChildren();

    if (children.isEmpty) return null;
    List<NotificationModel> notificationsModels =
        notifications.map((item) => NotificationModel.fromMap(item)).toList();
    List<ChildModel> childrenModels =
        children.map((item) => ChildModel.fromMap(item)).toList();

    List<NotificationWithChild> result = [];

    for (var notification in notificationsModels) {
      result.add(NotificationWithChild(
          notification,
          childrenModels
              .firstWhere((element) => element.id == notification.childId)));
    }

    return result;
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
