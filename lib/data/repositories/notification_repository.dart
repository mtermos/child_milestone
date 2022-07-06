import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/data/models/notification.dart';

class NotificationRepository {
  final notificationDao;
  final childDao;
  final milestoneDao;

  NotificationRepository(
      this.notificationDao, this.childDao, this.milestoneDao);

  Future getAllNotifications() async {
    List<Map<String, dynamic>> result =
        await notificationDao.getAllNotifications();

    return result.isNotEmpty
        ? result.map((item) => NotificationModel.fromMap(item)).toList()
        : null;
  }

  Future<List<NotificationWithChildAndMilestone>?>
      getAllNotificationsWithChildren() async {
    List<Map<String, dynamic>> notifications =
        await notificationDao.getAllNotifications();

    if (notifications.isEmpty) return null;

    List<Map<String, dynamic>> children = await childDao.getAllChildren();
    List<Map<String, dynamic>> milestones = await milestoneDao.getAllMilestones();

    if (children.isEmpty || milestones.isEmpty) return null;
    List<NotificationModel> notificationsModels =
        notifications.map((item) => NotificationModel.fromMap(item)).toList();

    List<ChildModel> childrenModels =
        children.map((item) => ChildModel.fromMap(item)).toList();
    List<MilestoneItem> milestonesModels =
        milestones.map((item) => MilestoneItem.fromMap(item)).toList();

    List<NotificationWithChildAndMilestone> result = [];

    for (var notification in notificationsModels) {
      MilestoneItem? milestoneItem;
      if (notification.milestoneId != null) {
        milestoneItem = milestonesModels
            .firstWhere((element) => element.id == notification.milestoneId);
      }
      result.add(NotificationWithChildAndMilestone(
          notification: notification,
          child: childrenModels
              .firstWhere((element) => element.id == notification.childId),
          milestone: milestoneItem));
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

  Future<DaoResponse<bool, int>> dismissNotification(
      NotificationModel notification) async {
    notification.dismissed = true;
    int count = await notificationDao.updateNotification(notification);
    if (count == 1) {
      return const DaoResponse(true, 1);
    } else {
      return DaoResponse(false, count);
    }
  }
}
