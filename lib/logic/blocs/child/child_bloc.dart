import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/constants/tuples.dart';
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
    on<GetAllChildrenEvent>(getAllChildren);
    on<DeleteAllChildrenEvent>(deleteAllChildren);

    on<GetChildEvent>(getChild);
  }

  void addChild(AddChildEvent event, Emitter<ChildState> emit) async {
    emit(AddingChildState());
    DaoResponse result = await childRepository.insertChild(event.child);
    print('result: ${result.item2}');
    if (result.item1) {
      emit(AddedChildState(event.child));
      if (event.addNotifications) {
        await _addPeriodsNotifications(event.context, event.child);
      }
      event.whenDone();
    } else if (result.item2 == 2067) {
      emit(ErrorAddingChildUniqueIDState());
    } else {
      emit(ErrorAddingChildState());
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
    DateTime after2Years = DateTime(child.date_of_birth.year + 2,
        child.date_of_birth.month, child.date_of_birth.day + 1);
    DateTime temp = child.date_of_birth;
    List<DateTime> weeklyTemps = [];

    int period = 0;
    while (temp.isBefore(after2Years)) {
      period++;
      temp = temp.toLocal();

      if (temp.hour > 10) {
        temp = DateTime(temp.year, temp.month + 2, temp.day + 1, 10);
      } else {
        temp = DateTime(temp.year, temp.month + 2, temp.day, 10);
      }
      weeklyTemps.add(temp.add(const Duration(days: 14)));
      weeklyTemps.add(temp.add(const Duration(days: 14)));
      weeklyTemps.add(temp.add(const Duration(days: 14)));
      weeklyTemps.add(temp.add(const Duration(days: 14)));

      String title = AppLocalizations.of(context)!.newPeriodNotificationTitle;
      String body = AppLocalizations.of(context)!.newPeriodNotificationBody1 +
          child.name +
          AppLocalizations.of(context)!.newPeriodNotificationBody2;

      NotificationModel notification = NotificationModel(
        title: title,
        body: body,
        issuedAt: temp,
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
        scheduledDate: tz.TZDateTime.from(temp, tz.local),
      );

      for (var weeklyTemp in weeklyTemps) {
        _addWeeklyNotification(weeklyTemp, period, context, child);
      }
    }
  }

  Future _addWeeklyNotification(DateTime dateTime, int period,
      BuildContext context, ChildModel child) async {
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
    String body = AppLocalizations.of(context)!.weeklyNotificationBody1 +
        child.name +
        AppLocalizations.of(context)!.weeklyNotificationBody2;

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
}
