import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/notification.dart';

var notificationsItems = [
  NotificationModel(
    id: 1,
    title: "Temp Temp 1",
    body: "لديه موعد مع الطبيب غدا",
    // body: "has an appointment with the doctor tomorrow",
    issuedAt: DateTime.now(),
    opened: true,
    dismissed: false,
    route: milestoneRoute,
    childId: 1,
    milestoneId: 1,
  ),
  NotificationModel(
    id: 2,
    title: "Temp Temp 2",
    body: "لديه موعد مع الطبيب غدا",
    issuedAt: DateTime.now().subtract(const Duration(hours: 1)),
    opened: false,
    dismissed: false,
    route: milestoneRoute,
    childId: 1,
    milestoneId: 2,
  ),
  NotificationModel(
    id: 3,
    title: "Temp Temp 3",
    body: "لديه موعد مع الطبيب غدا",
    issuedAt: DateTime.now().subtract(const Duration(days: 1)),
    opened: true,
    dismissed: false,
    route: milestoneRoute,
    childId: 2,
  ),
  NotificationModel(
    id: 4,
    title: "Temp Temp 4",
    body: "لديه موعد مع الطبيب غدا",
    issuedAt: DateTime.now().subtract(const Duration(days: 5)),
    opened: false,
    dismissed: false,
    route: milestoneRoute,
    childId: 2,
  ),
  NotificationModel(
    id: 5,
    title: "Temp Temp 4",
    body: "لديه موعد مع الطبيب غدا",
    issuedAt: DateTime.now().subtract(const Duration(days: 10)),
    opened: false,
    dismissed: false,
    route: milestoneRoute,
    childId: 2,
  ),
];
