import 'package:child_milestone/constants/monthly_periods.dart';
import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/constants/yearly_periods.dart';
import 'package:child_milestone/data/models/notification.dart';
import 'package:child_milestone/data/repositories/notification_repository.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/models/child_model.dart';
import '../../../data/repositories/child_repository.dart';

part "child_event.dart";
part "child_state.dart";

class ChildBloc extends Bloc<ChildEvent, ChildState> {
  final ChildRepository childRepository;
  final NotificationRepository notificationRepository;
  final NotificationService _notificationService = NotificationService();

  ChildBloc(
      {required this.childRepository, required this.notificationRepository})
      : super(InitialChildState()) {
    on<AddChildEvent>(addChild);
    on<EditChildEvent>(editChild);
    on<GetAllChildrenEvent>(getAllChildren);
    on<DeleteAllChildrenEvent>(deleteAllChildren);
    on<DeleteChildEvent>(deleteChild);

    on<GetChildEvent>(getChild);
  }

  void addChild(AddChildEvent event, Emitter<ChildState> emit) async {
    emit(AddingChildState());
    DaoResponse result = await childRepository.insertChild(event.child);
    if (result.item1) {
      if (event.addNotifications) {
        await _addPeriodsNotifications(event.context, event.child);
      }
      event.whenDone();
      emit(AddedChildState(event.child));
    } else if (result.item2 == 2067) {
      emit(ErrorAddingChildUniqueIDState());
    } else {
      emit(ErrorAddingChildState());
    }
  }

  void editChild(EditChildEvent event, Emitter<ChildState> emit) async {
    emit(EditingChildState());
    DaoResponse result = await childRepository.updateChild(event.child);
    if (result.item1) {
      if (event.addNotifications) {
        await _deleteAllNotifications(event.child.id);
        await _addPeriodsNotifications(event.context, event.child);
      }
      event.whenDone();
      emit(EditedChildState(event.child));
    } else {
      emit(ErrorEditingChildState());
    }
  }

  void getAllChildren(
      GetAllChildrenEvent event, Emitter<ChildState> emit) async {
    emit(AllChildrenLoadingState());
    List<ChildModel>? children = await childRepository.getAllChildren();
    if (children != null) {
      emit(AllChildrenLoadedState(children));
    } else {
      emit(AllChildrenLoadingErrorState());
    }
  }

  void deleteAllChildren(
      DeleteAllChildrenEvent event, Emitter<ChildState> emit) async {
    emit(DeleteingAllChildrenState());
    await childRepository.deleteAllChildren();
    emit(DeletedAllChildrenState());
  }

  void deleteChild(DeleteChildEvent event, Emitter<ChildState> emit) async {
    emit(DeletingChildState());
    _deleteAllNotifications(event.id);
    await childRepository.deleteChildById(event.id);
    emit(DeletedChildState());
  }

  void getChild(GetChildEvent event, Emitter<ChildState> emit) async {
    emit(ChildLoadingState());
    ChildModel? child = await childRepository.getChildByID(event.id);
    if (child != null) {
      emit(ChildLoadedState(child));
    } else {
      emit(ChildLoadingErrorState());
    }
  }

  Future _addPeriodsNotifications(
      BuildContext context, ChildModel child) async {
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
        _addWeeklyNotifications(
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
        _addWeeklyNotifications(
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
        _notificationService.cancelNotifications(notification.id!);
      }
    }
    await notificationRepository.deleteAllNotificationsByChildId(childId);
  }
}
