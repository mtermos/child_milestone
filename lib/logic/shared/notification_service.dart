import 'package:child_milestone/constants/monthly_periods.dart';
import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/constants/yearly_periods.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/log.dart';
import 'package:child_milestone/data/models/notification.dart';
import 'package:child_milestone/data/repositories/notification_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationService {
  //NotificationService a singleton object
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotification,
      onDidReceiveBackgroundNotificationResponse: selectNotification,
    );
  }

  AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    channelDescription: 'channel description',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  Future<void> showNotifications(
      {required String title, required String body}) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(android: _androidNotificationDetails),
    );
  }

  Future<void> scheduleNotifications({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        NotificationDetails(android: _androidNotificationDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

void selectNotification(NotificationResponse details) async {
  // print('details: ${details}');
  final dbProvider = DatabaseProvider.dbProvider;
  final db = await dbProvider.database;
  DateTime dateTime = DateTime.now();
  LogModel logModel = LogModel(
      action: "open notification",
      description: "The user pressed on a notification on: $dateTime",
      takenAt: dateTime);
  await db.insert(logsTABLE, logModel.toMap());
}

Future addPeriodsNotifications(AppLocalizations appLocalizations,
    ChildModel child, NotificationRepository notificationRepository) async {
  final NotificationService _notificationService = NotificationService();
  int correctingWeeks = 37 - child.pregnancyDuration;
  if (correctingWeeks < 0) correctingWeeks = 0;
  DateTime temp;

  // adding the monthly periods (10 periods)
  for (var period in monthlyPeriods) {
    temp = child.dateOfBirth
        .toLocal()
        .subtract(Duration(days: correctingWeeks * 7));

    if (temp.hour >= 10) {
      temp = DateTime(
          temp.year, temp.month + period.startingMonth, temp.day + 1, 10);
    } else {
      temp =
          DateTime(temp.year, temp.month + period.startingMonth, temp.day, 10);
    }

    if (temp.isAfter(DateTime.now())) {
      String title = appLocalizations.newPeriodNotificationTitle;
      String body = "";
      if (child.gender == "Male") {
        body = appLocalizations.newPeriodNotificationBody1male +
            child.name +
            appLocalizations.newPeriodNotificationBody2male;
      } else {
        body = appLocalizations.newPeriodNotificationBody1female +
            child.name +
            appLocalizations.newPeriodNotificationBody2female;
      }

      NotificationModel notification = NotificationModel(
        title: title,
        body: body,
        issuedAt: temp,
        opened: false,
        dismissed: false,
        route: Routes.milestone,
        period: period.id,
        endingAge: 1000,
        childId: child.id,
      );
      DaoResponse<bool, int> response =
          await notificationRepository.insertNotification(notification);
      notification.id = response.item2;
      _notificationService.scheduleNotifications(
        id: response.item2,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(temp, tz.local),
      );

      //adding doctor appointment notification
      // String title2 = appLocalizations.newDoctorAppNotificationTitle;

      // String body2 = "";
      // if (child.gender == "Male") {
      //   body2 = appLocalizations.newDoctorAppNotificationBody1male +
      //       child.name +
      //       appLocalizations.newDoctorAppNotificationBody2male;
      // } else {
      //   body2 = appLocalizations.newDoctorAppNotificationBody1female +
      //       child.name +
      //       appLocalizations.newDoctorAppNotificationBody2female;
      // }

      // NotificationModel notification2 = NotificationModel(
      //   title: title2,
      //   body: body2,
      //   issuedAt: temp,
      //   opened: false,
      //   dismissed: false,
      //   route: Routes.milestone,
      //   period: period.id,
      //   childId: child.id,
      // );
      // DaoResponse<bool, int> response2 =
      //     await notificationRepository.insertNotification(notification2);
      // notification2.id = response2.item2;
      // _notificationService.scheduleNotifications(
      //   id: response2.item2,
      //   title: title2,
      //   body: body2,
      //   scheduledDate: tz.TZDateTime.from(temp, tz.local),
      // );
    }

    for (var i = 1; i <= period.numWeeks; i++) {
      _addWeeklyNotifications(temp.add(Duration(days: 7 * i)), period.id,
          appLocalizations, child, notificationRepository);
    }
  }

  // adding the yearly periods (2 periods)
  for (var period in yearlyPeriods) {
    temp = child.dateOfBirth
        .toLocal()
        .subtract(Duration(days: correctingWeeks * 7));

    if (temp.hour >= 10) {
      temp = DateTime(
          temp.year + period.startingYear, temp.month, temp.day + 1, 10);
    } else {
      temp =
          DateTime(temp.year + period.startingYear, temp.month, temp.day, 10);
    }
    if (temp.isAfter(DateTime.now())) {
      String title = appLocalizations.newPeriodNotificationTitle;

      String body = "";
      if (child.gender == "Male") {
        body = appLocalizations.newPeriodNotificationBody1male +
            child.name +
            appLocalizations.newPeriodNotificationBody2male;
      } else {
        body = appLocalizations.newPeriodNotificationBody1female +
            child.name +
            appLocalizations.newPeriodNotificationBody2female;
      }

      NotificationModel notification = NotificationModel(
        title: title,
        body: body,
        issuedAt: temp,
        opened: false,
        dismissed: false,
        route: Routes.milestone,
        period: period.id,
        endingAge: 1000,
        childId: child.id,
      );
      DaoResponse<bool, int> response =
          await notificationRepository.insertNotification(notification);
      notification.id = response.item2;
      _notificationService.scheduleNotifications(
        id: response.item2,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(temp, tz.local),
      );

      //adding doctor appointment notification
      // String title2 = appLocalizations.newDoctorAppNotificationTitle;

      // String body2 = "";
      // if (child.gender == "Male") {
      //   body2 = appLocalizations.newDoctorAppNotificationBody1male +
      //       child.name +
      //       appLocalizations.newDoctorAppNotificationBody2male;
      // } else {
      //   body2 = appLocalizations.newDoctorAppNotificationBody1female +
      //       child.name +
      //       appLocalizations.newDoctorAppNotificationBody2female;
      // }

      // NotificationModel notification2 = NotificationModel(
      //   title: title2,
      //   body: body2,
      //   issuedAt: temp,
      //   opened: false,
      //   dismissed: false,
      //   route: Routes.milestone,
      //   period: period.id,
      //   childId: child.id,
      // );
      // DaoResponse<bool, int> response2 =
      //     await notificationRepository.insertNotification(notification2);
      // notification2.id = response2.item2;
      // _notificationService.scheduleNotifications(
      //   id: response2.item2,
      //   title: title2,
      //   body: body2,
      //   scheduledDate: tz.TZDateTime.from(temp, tz.local),
      // );
    }
    for (var i = 1; i <= period.numWeeks; i++) {
      _addWeeklyNotifications(temp.add(Duration(days: 7 * i)), period.id,
          appLocalizations, child, notificationRepository);
    }
  }
}

Future _addWeeklyNotifications(
    DateTime dateTime,
    int period,
    AppLocalizations appLocalizations,
    ChildModel child,
    NotificationRepository notificationRepository) async {
  if (dateTime.isBefore(DateTime.now())) return;
  final NotificationService _notificationService = NotificationService();
  // const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //     AndroidNotificationDetails(
  //         'repeating channel id', 'repeating channel name',
  //         channelDescription: 'repeating description');
  // const NotificationDetails platformChannelSpecifics =
  //     NotificationDetails(android: androidPlatformChannelSpecifics);
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
  //     'repeating body', RepeatInterval.weekly, platformChannelSpecifics,
  //     androidAllowWhileIdle: true);

  String title = appLocalizations.weeklyNotificationTitle;
  String body = "";

  if (child.gender == "Male") {
    body = appLocalizations.weeklyNotificationBody1male +
        child.name +
        appLocalizations.weeklyNotificationBody2;
  } else {
    body = appLocalizations.weeklyNotificationBody1female +
        child.name +
        appLocalizations.weeklyNotificationBody2;
  }

  DateTime nowDate = DateTime.now();
  DateTime dateOfBirth;
  if (child.pregnancyDuration.toInt() < 37) {
    int daysCorrected = (37 - child.pregnancyDuration.toInt()) * 7;
    dateOfBirth = child.dateOfBirth.add(Duration(days: daysCorrected));
  } else {
    dateOfBirth = child.dateOfBirth;
  }

  if (dateOfBirth.isAfter(nowDate)) return -1;

  final int diff = dateTime.difference(dateOfBirth).inDays ~/ 30.44;
  if (period == 1) {
    print('DIFF: ${diff}');
  }

  NotificationModel notification = NotificationModel(
    title: title,
    body: body,
    issuedAt: dateTime,
    opened: false,
    dismissed: false,
    route: Routes.milestone,
    period: period,
    endingAge: diff,
    childId: child.id,
  );
  DaoResponse<bool, int> response =
      await notificationRepository.insertNotification(notification);
  notification.id = response.item2;
  _notificationService.scheduleNotifications(
    id: response.item2,
    title: title,
    body: body,
    scheduledDate: tz.TZDateTime.from(dateTime, tz.local),
  );
}
