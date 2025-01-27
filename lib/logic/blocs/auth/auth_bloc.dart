import 'dart:convert';
import 'package:child_milestone/constants/tuples.dart';
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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import 'auth_state.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final storage = const FlutterSecureStorage();
  final ChildRepository childRepository;
  final DecisionRepository decisionRepository;
  final RatingRepository ratingRepository;
  final NotificationRepository notificationRepository;

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
          await getChildFromBackend(childID, event.appLocalizations);
        }

        if (responseBody["data"]["user"]["rating"] != null) {
          List<dynamic> ratings = responseBody["data"]["user"]["rating"];
          if (ratings.isNotEmpty) {
            await ratingRepository.insertRating(
              RatingModel(
                ratingId: 0,
                rating: 0,
                multipleRatings: "",
                additionalText: "already rated",
                uploaded: true,
                takenAt: DateTime.now(),
              ),
            );
          }
        }

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
      String childId, AppLocalizations appLocalizations) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(SharedPrefKeys.accessToken);
    // String? parentID = prefs.getString(SharedPrefKeys.userID);

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
            validateStatus: (status) =>
                true, // for testing accounts there would be some cases where a child for a specific ID is not found so a 404 is returned by the server
          ),
        );
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
            Map data = {};
            if (response.data["data"]["child"]["data"].runtimeType == String) {
              data = json.decode(response.data["data"]["child"]["data"]);
            } else {
              data = response.data["data"]["child"]["data"];
            }
            if (data["milestones"] != null) {
              milestonesDecisions = data["milestones"];
            }
            if (data["childID"] != null) {
              frontendID = data["childID"];
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

          await createChild(child, appLocalizations);
          await createMilestonesDecisions(milestonesDecisions, frontendID);
          await createVaccinesDecisions(vaccinesDecisions, frontendID);
          prefs.setInt(SharedPrefKeys.selectedChildId, child.id);
          return null;
        } else if (response.statusCode == 404) {
          return null;
        } else {
          return "response not 200";
        }
      } catch (e) {
        print('getChildFromBackend error: ${e}');
        return "connection failed";
      }
    }
    return "token not available";
  }

  Future<bool> createChild(
      ChildModel child, AppLocalizations appLocalizations) async {
    DaoResponse result = await childRepository.insertChild(child);
    if (result.item1) {
      addPeriodsNotifications(appLocalizations, child, notificationRepository);
      // if (addNotifications) {
      //   await _addPeriodsNotifications(appLocalizations, child);
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
