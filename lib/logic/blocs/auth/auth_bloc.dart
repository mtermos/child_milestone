import 'dart:convert';
import 'package:child_milestone/constants/monthly_periods.dart';
import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/constants/yearly_periods.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/notification.dart';
import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/data/repositories/notification_repository.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:dio/dio.dart';

import 'package:bloc/bloc.dart';
import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/repositories/child_repository.dart';
import 'package:child_milestone/data/repositories/decision_repository.dart';
import 'package:child_milestone/data/repositories/rating_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;

import 'auth_state.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final storage = const FlutterSecureStorage();
  final ChildRepository childRepository;
  final DecisionRepository decisionRepository;
  final RatingRepository ratingRepository;
  final NotificationRepository notificationRepository;
  final NotificationService _notificationService = NotificationService();

  AuthBloc({
    required this.childRepository,
    required this.decisionRepository,
    required this.ratingRepository,
    required this.notificationRepository,
  }) : super(UnlogedState()) {
    on<LoginEvent>(_login);
    on<LogoutEvent>(_logout);
  }

  void _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingLoginState());

    try {
      final response = await http.post(
        Uri.parse(Urls.backendUrl + Urls.loginUrl),
        body: {"email": event.username, "password": event.password},
      );
      var responseBody = json.decode(response.body);
      print('responseBody: ${responseBody}');
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(SharedPrefKeys.isLogged, true);
        await prefs.setString(
            SharedPrefKeys.accessToken, responseBody["token"]);
        await prefs.setString(
            SharedPrefKeys.userID, responseBody["data"]["user"]["id"]);
        // await storage.write(key: SharedPrefKeys.accessToken, value: "token");
        await storage.write(key: StorageKeys.username, value: event.username);
        await storage.write(key: StorageKeys.password, value: event.password);

        List<dynamic> childrenIDs =
            responseBody["data"]["user"]["children"] ?? [];
        for (String childID in childrenIDs) {
          String? response = await getChildFromBackend(childID, event.context);
        }

        List<dynamic> ratings = responseBody["data"]["user"]["rating"];
        for (var rating in ratings) {
          double ratingValue = 0.0;
          if (rating["rating"] is String) {
            ratingValue = double.parse(rating["rating"]);
          } else {
            ratingValue = rating["rating"].toDouble();
          }
          await ratingRepository.insertRating(
            RatingModel(
              ratingId: rating["ratingId"] as int,
              rating: ratingValue,
              uploaded: true,
              takenAt:
                  DateTime.fromMillisecondsSinceEpoch(rating["takenAt"] as int),
            ),
          );
        }

        print('LogedState: ${LogedState}');
        emit(LogedState());
        event.onSuccess();
      } else {
        print('LoginErrorState: ${LoginErrorState}');
        emit(LoginErrorState(error: responseBody["message"] ?? ""));
      }
    } catch (e) {
      print('error: ${e}');
      emit(LoginErrorState(error: e.toString()));
    }
  }

  void _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(LoadingLogoutState());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final dbProvider = DatabaseProvider.dbProvider;
    final db = await dbProvider.database;
    await db.delete(childrenTABLE);
    await db.delete(milestonesTABLE);
    await db.delete(vaccinesTABLE);
    await db.delete(tipsTABLE);
    await db.delete(notificationsTABLE);
    await db.delete(decisionsTABLE);
    await db.delete(ratingsTABLE);

    NotificationService _notificationService = NotificationService();
    await _notificationService.cancelAllNotifications();

    // final response = await http.post(Uri.parse(Urls.backendUrl + Urls.loginUrl));

    event.onSuccess();

    emit(UnlogedState());
  }

  Future<String?> getChildFromBackend(
      String childId, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SharedPrefKeys.accessToken);
    String? parentID = prefs.getString(SharedPrefKeys.userID);

    if (token != null) {
      try {
        final dio = Dio();
        final response = await dio.get(
          Urls.backendUrl + Urls.getChildUrl,
          data: {'id': childId},
          options: Options(
            headers: {
              "Authorization": "Bearer " + token,
            },
          ),
        );
        print('response: ${response.data}');
        if (response.statusCode == 201) {
          DateTime dateOfBirth =
              DateTime.parse(response.data["data"]["child"]["dateOfBirth"]);
          int frontendID = dateOfBirth.millisecondsSinceEpoch;
          List milestonesDecisions = [];
          List vaccinesDecisions = [];
          if (response.data["data"]["child"]["active"] != null &&
              response.data["data"]["child"]["active"] == 0) {
            return null;
          }

          if (response.data["data"]["child"]["data"] != null) {
            // Map data = response.data["data"]["child"]["data"];
            Map data = json.decode(response.data["data"]["child"]["data"]);
            if (data["milestones"] != null) {
              milestonesDecisions = data["milestones"];
            }
            if (data["childID"] != null) {
              int frontendID = data["childID"];
            }
            if (data["vaccines"] != null) {
              vaccinesDecisions = data["vaccines"];
            }
          }

          // dateOfBirth.millisecondsSinceEpoch;
          ChildModel child = ChildModel(
              id: frontendID,
              name: response.data["data"]["child"]["childName"],
              dateOfBirth: dateOfBirth,
              imagePath: "",
              idBackend: childId,
              gender: response.data["data"]["child"]["gender"],
              uploaded: true,
              pregnancyDuration:
                  response.data["data"]["child"]["pregnancyDuration"] as int);
          await createChild(child, context);
          await createMilestonesDecisions(milestonesDecisions, frontendID);
          await createVaccinesDecisions(vaccinesDecisions, frontendID);
          prefs.setInt(SharedPrefKeys.selectedChildId, child.id);
          return null;
        } else {
          return "response not 200";
        }
      } catch (e) {
        print('e: ${e}');
        return "connection failed";
      }
    }
    return "token not available";
  }

  Future<bool> createChild(ChildModel child, BuildContext context) async {
    DaoResponse result = await childRepository.insertChild(child);
    if (result.item1) {
      await addPeriodsNotifications(context, child);
      // if (addNotifications) {
      //   await _addPeriodsNotifications(event.context, child);
      // }
      // whenDone();
    }
    return true;
  }

  createMilestonesDecisions(List decisionsJSON, int childID) async {
    List<DecisionModel> decisionsList = [];
    for (var decisionJSON in decisionsJSON) {
      decisionsList.add(
        DecisionModel(
            childId: childID,
            milestoneId: decisionJSON["number"],
            vaccineId: 0,
            decision: decisionJSON["decision"] as int,
            takenAt: DateTime.fromMillisecondsSinceEpoch(
                decisionJSON['takenAt'] as int)),
      );
    }

    DaoResponse resultMilestones =
        await decisionRepository.insertDecisionsList(decisionsList);
  }

  createVaccinesDecisions(List decisionsJSON, int childID) async {
    List<DecisionModel> decisionsList = [];
    for (var decisionJSON in decisionsJSON) {
      decisionsList.add(
        DecisionModel(
            childId: childID,
            milestoneId: 0,
            vaccineId: decisionJSON["number"],
            decision: decisionJSON["decision"] as int,
            takenAt: DateTime.fromMillisecondsSinceEpoch(
                decisionJSON['takenAt'] as int)),
      );
    }

    DaoResponse resultMilestones =
        await decisionRepository.insertDecisionsList(decisionsList);
  }

  // List<DecisionModel> decisionsFromJSON(
  //     String decisionsJSON, int childId) {
  //   // print(json.decode(decisionsJSON));
  //   List items = json.decode(decisionsJSON)["milestones"] as List;
  //   List<DecisionModel> decisions = [];
  //   for (var item in items) {
  //     decisions.add(
  //       DecisionModel(
  //           childId: childId,
  //           milestoneId: item["number"],
  //           vaccineId: 0,
  //           decision: item["decision"] as int,
  //           takenAt:
  //               DateTime.fromMillisecondsSinceEpoch(item['takenAt'] as int)),
  //     );
  //   }
  //   return decisions;
  // }

  Future addPeriodsNotifications(BuildContext context, ChildModel child) async {
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
        temp = DateTime(
            temp.year, temp.month + period.startingMonth, temp.day, 10);
      }

      if (temp.isAfter(DateTime.now())) {
        String title = AppLocalizations.of(context)!.newPeriodNotificationTitle;
        String body = "";
        if (child.gender == "Male") {
          body = AppLocalizations.of(context)!.newPeriodNotificationBody1male +
              child.name +
              AppLocalizations.of(context)!.newPeriodNotificationBody2male;
        } else {
          body = AppLocalizations.of(context)!
                  .newPeriodNotificationBody1female +
              child.name +
              AppLocalizations.of(context)!.newPeriodNotificationBody2female;
        }

        NotificationModel notification = NotificationModel(
          title: title,
          body: body,
          issuedAt: temp,
          opened: false,
          dismissed: false,
          route: Routes.milestone,
          period: period.id,
          childId: child.id,
        );
        DaoResponse<bool, int> response =
            await notificationRepository.insertNotification(notification);
        notification.id = response.item2;
        await _notificationService.scheduleNotifications(
          id: response.item2,
          title: title,
          body: body,
          scheduledDate: tz.TZDateTime.from(temp, tz.local),
        );

        //adding doctor appointment notification
        String title2 =
            AppLocalizations.of(context)!.newDoctorAppNotificationTitle;

        String body2 = "";
        if (child.gender == "Male") {
          body2 = AppLocalizations.of(context)!
                  .newDoctorAppNotificationBody1male +
              child.name +
              AppLocalizations.of(context)!.newDoctorAppNotificationBody2male;
        } else {
          body2 = AppLocalizations.of(context)!
                  .newDoctorAppNotificationBody1female +
              child.name +
              AppLocalizations.of(context)!.newDoctorAppNotificationBody2female;
        }

        NotificationModel notification2 = NotificationModel(
          title: title2,
          body: body2,
          issuedAt: temp,
          opened: false,
          dismissed: false,
          route: Routes.milestone,
          period: period.id,
          childId: child.id,
        );
        DaoResponse<bool, int> response2 =
            await notificationRepository.insertNotification(notification2);
        notification2.id = response2.item2;
        await _notificationService.scheduleNotifications(
          id: response2.item2,
          title: title2,
          body: body2,
          scheduledDate: tz.TZDateTime.from(temp, tz.local),
        );
      }

      for (var i = 1; i <= period.numWeeks; i++) {
        await _addWeeklyNotifications(
            temp.add(Duration(days: 7 * i)), period.id, context, child);
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
        String title = AppLocalizations.of(context)!.newPeriodNotificationTitle;

        String body = "";
        if (child.gender == "Male") {
          body = AppLocalizations.of(context)!.newPeriodNotificationBody1male +
              child.name +
              AppLocalizations.of(context)!.newPeriodNotificationBody2male;
        } else {
          body = AppLocalizations.of(context)!
                  .newPeriodNotificationBody1female +
              child.name +
              AppLocalizations.of(context)!.newPeriodNotificationBody2female;
        }

        NotificationModel notification = NotificationModel(
          title: title,
          body: body,
          issuedAt: temp,
          opened: false,
          dismissed: false,
          route: Routes.milestone,
          period: period.id,
          childId: child.id,
        );
        DaoResponse<bool, int> response =
            await notificationRepository.insertNotification(notification);
        notification.id = response.item2;
        await _notificationService.scheduleNotifications(
          id: response.item2,
          title: title,
          body: body,
          scheduledDate: tz.TZDateTime.from(temp, tz.local),
        );

        //adding doctor appointment notification
        String title2 =
            AppLocalizations.of(context)!.newDoctorAppNotificationTitle;

        String body2 = "";
        if (child.gender == "Male") {
          body2 = AppLocalizations.of(context)!
                  .newDoctorAppNotificationBody1male +
              child.name +
              AppLocalizations.of(context)!.newDoctorAppNotificationBody2male;
        } else {
          body2 = AppLocalizations.of(context)!
                  .newDoctorAppNotificationBody1female +
              child.name +
              AppLocalizations.of(context)!.newDoctorAppNotificationBody2female;
        }

        NotificationModel notification2 = NotificationModel(
          title: title2,
          body: body2,
          issuedAt: temp,
          opened: false,
          dismissed: false,
          route: Routes.milestone,
          period: period.id,
          childId: child.id,
        );
        DaoResponse<bool, int> response2 =
            await notificationRepository.insertNotification(notification2);
        notification2.id = response2.item2;
        await _notificationService.scheduleNotifications(
          id: response2.item2,
          title: title2,
          body: body2,
          scheduledDate: tz.TZDateTime.from(temp, tz.local),
        );
      }
      for (var i = 1; i <= period.numWeeks; i++) {
        await _addWeeklyNotifications(
            temp.add(Duration(days: 7 * i)), period.id, context, child);
      }
    }
  }

  Future _addWeeklyNotifications(DateTime dateTime, int period,
      BuildContext context, ChildModel child) async {
    if (dateTime.isBefore(DateTime.now())) return;
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

    String title = AppLocalizations.of(context)!.weeklyNotificationTitle;
    String body = "";

    if (child.gender == "Male") {
      body = AppLocalizations.of(context)!.weeklyNotificationBody1male +
          child.name +
          AppLocalizations.of(context)!.weeklyNotificationBody2;
    } else {
      body = AppLocalizations.of(context)!.weeklyNotificationBody1female +
          child.name +
          AppLocalizations.of(context)!.weeklyNotificationBody2;
    }

    NotificationModel notification = NotificationModel(
      title: title,
      body: body,
      issuedAt: dateTime,
      opened: false,
      dismissed: false,
      route: Routes.milestone,
      period: period,
      childId: child.id,
    );
    DaoResponse<bool, int> response =
        await notificationRepository.insertNotification(notification);
    notification.id = response.item2;
    await _notificationService.scheduleNotifications(
      id: response.item2,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(dateTime, tz.local),
    );
  }

  _deleteAllNotifications(int childId) async {
    List<NotificationModel> notifications =
        await notificationRepository.getNotificationsByChildId(childId);
    NotificationService _notificationService = NotificationService();
    for (var notification in notifications) {
      if (notification.id != null) {
        await _notificationService.cancelNotifications(notification.id!);
      }
    }
    await notificationRepository.deleteAllNotificationsByChildId(childId);
  }
}
