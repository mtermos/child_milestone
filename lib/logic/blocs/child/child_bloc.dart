import 'dart:convert';

import 'package:child_milestone/constants/monthly_periods.dart';
import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/constants/yearly_periods.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/data/models/notification.dart';
import 'package:child_milestone/data/models/rating.dart';
import 'package:child_milestone/data/models/vaccine.dart';
import 'package:child_milestone/data/repositories/decision_repository.dart';
import 'package:child_milestone/data/repositories/milestone_repository.dart';
import 'package:child_milestone/data/repositories/notification_repository.dart';
import 'package:child_milestone/data/repositories/rating_repository.dart';
import 'package:child_milestone/data/repositories/vaccine_repository.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/child_model.dart';
import '../../../data/repositories/child_repository.dart';

part "child_event.dart";
part "child_state.dart";

class ChildBloc extends Bloc<ChildEvent, ChildState> {
  final ChildRepository childRepository;
  final NotificationRepository notificationRepository;
  final DecisionRepository decisionRepository;
  final MilestoneRepository milestoneRepository;
  final VaccineRepository vaccineRepository;
  final RatingRepository ratingRepository;
  final NotificationService _notificationService = NotificationService();

  ChildBloc(
      {required this.childRepository,
      required this.notificationRepository,
      required this.decisionRepository,
      required this.milestoneRepository,
      required this.vaccineRepository,
      required this.ratingRepository})
      : super(InitialChildState()) {
    on<AddChildEvent>(addChild);
    on<EditChildEvent>(editChild);
    on<GetAllChildrenEvent>(getAllChildren);
    on<DeleteAllChildrenEvent>(deleteAllChildren);
    on<DeleteChildEvent>(deleteChild);

    on<GetChildEvent>(getChild);

    on<UploadChildrenEvent>(uploadChildren);
  }

  void addChild(AddChildEvent event, Emitter<ChildState> emit) async {
    emit(AddingChildState());
    String? errorUploading = await uploadChild(event.child);
    if (errorUploading == null) {
      DaoResponse result = await childRepository.insertChild(event.child);
      if (result.item1) {
        event.child.uploaded = true;
        // DaoResponse updateResult =
        //     await childRepository.updateChild(event.child);
        // if (updateResult.item1) {
        if (event.addNotifications) {
          await addPeriodsNotifications(event.context, event.child);
        }
        event.whenDone();
        emit(AddedChildState(event.child));
        // }
      } else if (result.item2 == 2067) {
        emit(ErrorAddingChildUniqueIDState());
      } else {
        print('ErrorAddingChildState: ${ErrorAddingChildState}');
        emit(ErrorAddingChildState());
      }
    } else {
      emit(ErrorAddingChildState());
    }
  }

  void editChild(EditChildEvent event, Emitter<ChildState> emit) async {
    emit(EditingChildState());
    String? errorUploading = await updateChildOnBackend(event.child);
    if (errorUploading == null) {
      DaoResponse result = await childRepository.updateChild(event.child);
      if (result.item1) {
        if (event.addNotifications) {
          await _deleteAllNotifications(event.child.id);
          await addPeriodsNotifications(event.context, event.child);
        }
        event.whenDone();
        emit(EditedChildState(event.child));
      } else {
        emit(ErrorEditingChildState());
      }
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
    List<ChildModel>? childrenModels = await childRepository.getAllChildren();
    if (childrenModels != null && childrenModels.isNotEmpty) {
      for (ChildModel childModel in childrenModels) {
        if (childModel != null && childModel.idBackend != null) {
          await deleteChildOnBackend(childModel.idBackend!);
        }
      }
    }
    await childRepository.deleteAllChildren();
    emit(DeletedAllChildrenState());
  }

  void deleteChild(DeleteChildEvent event, Emitter<ChildState> emit) async {
    emit(DeletingChildState());
    ChildModel? childModel = await childRepository.getChildByID(event.id);
    if (childModel != null && childModel.idBackend != null) {
      String? response = await deleteChildOnBackend(childModel.idBackend!);
      if (response == null) {
        _deleteAllNotifications(event.id);
        await childRepository.deleteChildById(event.id);
        emit(DeletedChildState());
        event.onSuccess();
      } else {
        emit(ErrorDeletingChildState());
        event.onFail();
      }
    } else {
      emit(ErrorDeletingChildState());
      event.onFail();
    }
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

  void uploadChildren(
      UploadChildrenEvent event, Emitter<ChildState> emit) async {
    emit(UploadingChildrenState());
    print("uploading... ");
    List<ChildModel> newChildren = (await childRepository.getAllChildren())
        .where((element) => !element.uploaded)
        .toList();
    bool noErrorsUploading = true;
    // for (var child in newChildren) {
    //   String? error = await uploadChild(child);
    //   if (error == null) {
    //     child.uploaded = true;
    //     await childRepository.updateChild(child);
    //   } else {
    //     noErrorsUploading = false;
    //     emit(ErrorUploadingChildrenState(error: error));
    //   }
    // }

    List<ChildModel> children =
        (await childRepository.getAllChildren()).toList();
    bool noErrorsUpdating = true;
    for (var child in children) {
      String? error = await updateChildOnBackend(child);
      if (error != null) {
        noErrorsUpdating = false;
        emit(ErrorUploadingChildrenState(error: error));
      }
    }

    List<RatingModel> newRatings = (await ratingRepository.getAllRatings())
        .where((element) => !element.uploaded)
        .toList();

    bool noErrorsRatings = true;
    if (newRatings.isNotEmpty) {
      String? error = await updateRatingOnBackend(event.context);
      if (error == null) {
        for (var rating in newRatings) {
          rating.uploaded = true;
          await ratingRepository.updateRating(rating);
        }
      } else {
        noErrorsRatings = false;
        emit(ErrorUploadingChildrenState(error: error));
      }
    }

    if (noErrorsUploading && noErrorsUpdating && noErrorsRatings)
      emit(UploadedChildrenState());
  }

  Future<String?> uploadChild(ChildModel childModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SharedPrefKeys.accessToken);
    String? parentID = prefs.getString(SharedPrefKeys.userID);
    if (token != null) {
      try {
        Object body = {
          "childName": childModel.name,
          "gender": childModel.gender,
          "pregnancyDuration": childModel.pregnancyDuration.toString(),
          "dateOfBirth": childModel.dateOfBirth.toString(),
          "parent_id": parentID,
          "data": json.encode({"childID": childModel.id}),
        };
        final response = await http.post(
          Uri.parse(Urls.backendUrl + Urls.createChildUrl),
          headers: {
            "Authorization": "Bearer " + token,
          },
          body: body,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          return null;
        } else {
          return "response not 200";
        }
      } catch (e) {
        return "connection failed";
      }
    }
    return "token not available";
  }

  Future<String?> updateChildOnBackend(ChildModel childModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SharedPrefKeys.accessToken);
    String? parentID = prefs.getString(SharedPrefKeys.userID);
    Map<String, dynamic> data = {};

    // data["milestones"] = await decisionsToJSON(childModel.id);
    // decisionsFromJSON(json.encode(data), childModel.id);

    if (token != null) {
      try {
        data["childID"] = childModel.id;
        data["milestones"] = await milestonesToJSON(childModel.id);
        // print("json encoded data: " + json.encode(data));
        data["vaccines"] = await vaccinesToJSON(childModel.id);
        Object body = {
          "id": childModel.idBackend!,
          "data": {
            "childName": childModel.name,
            "gender": childModel.gender,
            "pregnancyDuration": childModel.pregnancyDuration.toString(),
            "dateOfBirth": childModel.dateOfBirth.toString(),
            "parent_id": parentID,
            "data": json.encode(data),
          }
        };
        final response = await http.patch(
          Uri.parse(Urls.backendUrl + Urls.updateChildUrl),
          headers: {
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json",
          },
          body: json.encode(body),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          return null;
        } else {
          return "response not 200";
        }
      } catch (e) {
        return "connection failed";
      }
    }
    return "token not available";
  }

  Future<List> milestonesToJSON(int childID) async {
    List<MilestoneItem> milestones =
        await milestoneRepository.getAllMilestones();

    List data = [];
    // List<DecisionModel> decisions =
    //     await decisionRepository.getDecisionsByChild(child.id);
    for (var milestone in milestones) {
      DecisionModel? decisionModel = await decisionRepository
          .getDecisionByChildAndMilestone(childID, milestone.id);

      if (decisionModel != null) {
        // String decisionInWords = "";
        // if (decisionModel.decision == 1) decisionInWords = "Yes";
        // if (decisionModel.decision == 2) decisionInWords = "No";
        // if (decisionModel.decision == 3) decisionInWords = "Maybe";

        data.add({
          "number": milestone.id,
          "question": milestone.description,
          "category": milestone.category,
          "startingAge": milestone.startingAge,
          "endingAge": milestone.endingAge,
          "period": milestone.period,
          "decision": decisionModel.decision,
          "takenAt": decisionModel.takenAt.millisecondsSinceEpoch,
        });
      }
    }
    return data;
    // List decisions = decisionRepository.
  }

  Future<List> vaccinesToJSON(int childID) async {
    List<Vaccine> vaccines = await vaccineRepository.getAllVaccines();

    List data = [];
    // List<DecisionModel> decisions =
    //     await decisionRepository.getDecisionsByChild(child.id);
    for (var vaccine in vaccines) {
      DecisionModel? decisionModel = await decisionRepository
          .getDecisionByChildAndVaccine(childID, vaccine.id);

      if (decisionModel != null) {
        // String decisionInWords = "";
        // if (decisionModel.decision == 1) decisionInWords = "Yes";
        // if (decisionModel.decision == 2) decisionInWords = "No";
        // if (decisionModel.decision == 3) decisionInWords = "Maybe";

        data.add({
          "number": vaccine.id,
          "question": vaccine.description,
          "startingAge": vaccine.startingAge,
          "endingAge": vaccine.endingAge,
          "period": vaccine.period,
          "decision": decisionModel.decision,
          "takenAt": decisionModel.takenAt.millisecondsSinceEpoch,
        });
      }
    }
    return data;
    // List decisions = decisionRepository.
  }

  Future<String?> updateRatingOnBackend(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SharedPrefKeys.accessToken);
    String? userID = prefs.getString(SharedPrefKeys.userID);
    if (token != null && userID != null) {
      try {
        Map<String, dynamic> data = {};
        data["rating"] = await ratingsToJSON(context);
        Object body = {
          "id": userID,
          "data": json.encode(data),
        };
        final response = await http.patch(
          Uri.parse(Urls.backendUrl + Urls.userUpdateUrl),
          headers: {
            "Authorization": "Bearer " + token,
          },
          body: json.encode(body),
        );
        print('response.body: ${response.body}');
        if (response.statusCode == 200) {
          return null;
        } else {
          print('updateRatingOnBackend.response: response not 200');
          return "response not 200";
        }
      } catch (e) {
        print('updateRatingOnBackend.e: ${e}');
        return "connection failed";
      }
    }
    print('updateRatingOnBackend.error: token not available');
    return "token not available";
  }

  Future<List> ratingsToJSON(BuildContext context) async {
    List<RatingModel> ratings = await ratingRepository.getAllRatings();

    List data = [];

    Map<int, String> ratingsTexts = {
      1: AppLocalizations.of(context)!.appInterfaceRating,
      2: AppLocalizations.of(context)!.contentRating,
      3: AppLocalizations.of(context)!.educationalContentRating,
    };
    for (var rating in ratings) {
      data.add({
        "ratingId": rating.ratingId,
        "text": ratingsTexts[rating.ratingId],
        "rating": rating.rating,
        "takenAt": rating.takenAt.millisecondsSinceEpoch,
      });
    }
    return data;
  }

  Future<String?> deleteChildOnBackend(String backendID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SharedPrefKeys.accessToken);
    if (token != null) {
      try {
        Object body = {
          "id": backendID,
        };
        final response = await http.post(
          Uri.parse(Urls.backendUrl + Urls.createChildUrl),
          headers: {
            "Authorization": "Bearer " + token,
          },
          body: body,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          return null;
        } else {
          return "response not 200";
        }
      } catch (e) {
        return "connection failed";
      }
    }
    return "token not available";
  }
}
