import 'dart:async';

import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/data/models/notification.dart';
import 'package:child_milestone/data/models/vaccine.dart';
import 'package:child_milestone/data/repositories/child_repository.dart';
import 'package:child_milestone/data/repositories/decision_repository.dart';
import 'package:child_milestone/data/repositories/milestone_repository.dart';
import 'package:child_milestone/data/repositories/notification_repository.dart';
import 'package:child_milestone/data/repositories/vaccine_repository.dart';
import 'package:child_milestone/logic/shared/functions.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:child_milestone/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;

part 'decision_event.dart';
part 'decision_state.dart';

class DecisionBloc extends Bloc<DecisionEvent, DecisionState> {
  final DecisionRepository decisionRepository;
  final NotificationRepository notificationRepository;
  final ChildRepository childRepository;
  final MilestoneRepository milestoneRepository;
  final VaccineRepository vaccineRepository;
  final ChildBloc childBloc;
  late final StreamSubscription childBlocSubscription;

  DecisionBloc({
    required this.decisionRepository,
    required this.notificationRepository,
    required this.childRepository,
    required this.milestoneRepository,
    required this.vaccineRepository,
    required this.childBloc,
  }) : super(InitialDecisionState()) {
    on<AddDecisionEvent>(addDecision);
    on<GetAllDecisionsEvent>(getAllDecisions);
    on<DeleteAllDecisionsEvent>(deleteAllDecisions);

    on<GetDecisionEvent>(getDecision);
    on<GetDecisionsByChild>(getByChild);
    on<GetDecisionsByAgeEvent>(getByAge);
    on<GetDecisionByChildAndMilestoneEvent>(getByChildAndMilestone);
    on<GetDecisionByChildAndVaccineEvent>(getByChildAndVaccine);

    // on<UploadDecisionsEvent>(updateDecisionsOnBackend);
  }

  @override
  Future<void> close() {
    childBlocSubscription.cancel();
    return super.close();
  }

  void addDecision(AddDecisionEvent event, Emitter<DecisionState> emit) async {
    emit(AddingDecisionState());
    bool isMilestone = event.decision.milestoneId > 0;

    DaoResponse<bool, int> daoResponse =
        await decisionRepository.insertDecision(event.decision);

    if (!daoResponse.item1) {
      emit(DecisionErrorState("decision not added to the database"));
      return;
    }

    ChildModel? childModel =
        await childRepository.getChildByID(event.decision.childId);
    if (childModel == null) emit(DecisionErrorState("child not found"));

    bool allTakenResponse = await checkIfAllTakenIncThisPeriod(childModel!);
    bool allTakenResponseUntilToday =
        await checkIfAllTakenUntilToday(childModel);

    if (allTakenResponse) {
      await stopWeeklyNotifications(event.decision.childId);
    }
    if (allTakenResponseUntilToday) {
      await stopWeeklyNotificationsByMonth(event.decision.childId);
    }

    if (event.decision.decision != 1) {
      bool alertDoctor = await checkIfAlertDoctor(childModel);
      if (alertDoctor) {
        String title2 = event.appLocalizations.newDoctorAppNotificationTitle;

        String body2 = "";
        if (childModel.gender == "Male") {
          body2 = event.appLocalizations.newDoctorAppNotificationBody1male +
              childModel.name +
              event.appLocalizations.newDoctorAppNotificationBody2male;
        } else {
          body2 = event.appLocalizations.newDoctorAppNotificationBody1female +
              childModel.name +
              event.appLocalizations.newDoctorAppNotificationBody2female;
        }
        DateTime date = DateTime.now().add(const Duration(days: 5));

        NotificationModel notificationModel = NotificationModel(
          title: title2,
          body: body2,
          issuedAt: date,
          opened: false,
          dismissed: false,
          route: isMilestone ? Routes.milestone : Routes.vaccine,
          period: await getPeriod(event.decision),
          endingAge: await getEndingAge(event.decision),
          childId: event.decision.childId,
        );

        DaoResponse<bool, int> response =
            await notificationRepository.insertNotification(notificationModel);

        NotificationService _notificationService = NotificationService();

        notificationModel.id = response.item2;
        _notificationService.scheduleNotifications(
          id: response.item2,
          title: title2,
          body: body2,
          scheduledDate: tz.TZDateTime.from(date, tz.local),
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'lastAlertDoctoreDate', DateTime.now().toIso8601String());
      }
    }

    if (daoResponse.item1) {
      ChildModel? childModel =
          await childRepository.getChildByID(event.decision.childId);
      if (childModel == null) emit(DecisionErrorState("child not found"));
      childBloc.updateChildOnBackend(childModel!);
      emit(AddedDecisionState(event.decision));
      event.onSuccess();
    }
  }

  void getAllDecisions(
      GetAllDecisionsEvent event, Emitter<DecisionState> emit) async {
    emit(AllDecisionsLoadingState());
    // await decisionRepository.deleteAllDecisions();
    List<DecisionModel> decisions = await decisionRepository.getAllDecisions();
    emit(AllDecisionsLoadedState(decisions));
  }

  void deleteAllDecisions(
      DeleteAllDecisionsEvent event, Emitter<DecisionState> emit) async {
    emit(DeleteingAllDecisionsState());
    await decisionRepository.deleteAllDecisions();
    emit(DeletedAllDecisionsState());
  }

  void getDecision(GetDecisionEvent event, Emitter<DecisionState> emit) async {
    emit(DecisionLoadingState());
    DecisionModel? decision =
        await decisionRepository.getDecisionByID(event.decisionId);
    if (decision != null) {
      emit(DecisionLoadedState(decision));
    } else {
      emit(DecisionLoadingErrorState());
    }
  }

  void getByChild(
      GetDecisionsByChild event, Emitter<DecisionState> emit) async {
    emit(LoadingDecisionsByChildState());
    List<DecisionModel> daoResponse =
        await decisionRepository.getDecisionsByChild(event.childId);
    emit(LoadedDecisionsByChildState(daoResponse));
    // if (daoResponse.item1) {
    //   emit(LoadedDecisionsByAgeState(daoResponse.item1, daoResponse.item2));
    // } else {
    //   emit(ErrorLoadingDecisionsByAgeState());
    // }
  }

  void getByAge(
      GetDecisionsByAgeEvent event, Emitter<DecisionState> emit) async {
    emit(LoadingDecisionsByAgeState());
    DaoResponse<List<DecisionModel>, int> daoResponse =
        await decisionRepository.getDecisionsByAge(event.child);
    emit(LoadedDecisionsByAgeState(daoResponse.item1, daoResponse.item2));
    // if (daoResponse.item1) {
    //   emit(LoadedDecisionsByAgeState(daoResponse.item1, daoResponse.item2));
    // } else {
    //   emit(ErrorLoadingDecisionsByAgeState());
    // }
  }

  void getByChildAndMilestone(GetDecisionByChildAndMilestoneEvent event,
      Emitter<DecisionState> emit) async {
    emit(LoadingDecisionByChildAndMilestoneState());
    DecisionModel? decisionModel = await decisionRepository
        .getDecisionByChildAndMilestone(event.childId, event.milestoneId);

    if (decisionModel != null) {
      emit(LoadedDecisionByChildAndMilestoneState(decisionModel));
    }
    // if (daoResponse.item1) {
    //   emit(LoadedDecisionsByAgeState(daoResponse.item1, daoResponse.item2));
    // } else {
    //   emit(ErrorLoadingDecisionsByAgeState());
    // }
  }

  void getByChildAndVaccine(GetDecisionByChildAndVaccineEvent event,
      Emitter<DecisionState> emit) async {
    emit(LoadingDecisionByChildAndVaccineState());
    DecisionModel? decisionModel = await decisionRepository
        .getDecisionByChildAndVaccine(event.childId, event.vaccineId);

    if (decisionModel != null) {
      emit(LoadedDecisionByChildAndVaccineState(decisionModel));
    }
    // if (daoResponse.item1) {
    //   emit(LoadedDecisionsByAgeState(daoResponse.item1, daoResponse.item2));
    // } else {
    //   emit(ErrorLoadingDecisionsByAgeState());
    // }
  }

  // Future<bool> checkIfAllDecisions(int childId) async {
  //   List<DecisionModel> daoResponse =
  //       await decisionRepository.getDecisionsByChild(childId);
  //   List<MilestoneItem> daoResponseMilestones =
  //       await milestoneRepository.getAllMilestones();
  //   List<Vaccine> daoResponseVaccines =
  //       await vaccineRepository.getAllVaccines();

  //   for (var dec in daoResponse) {
  //     if (dec.decision < 1) return false;
  //   }
  //   return true;
  // }

  Future<bool> checkIfAllTakenIncThisPeriod(ChildModel child) async {
    int period = periodCalculator(child).id;
    if (period <= 1) return true;

    List<MilestoneItem>? milestones =
        await milestoneRepository.getMilestonesUntilPeriod(period);

    List<Vaccine>? vaccines =
        await vaccineRepository.getVaccinesUntilPeriod(period);

    if (milestones != null) {
      for (var milestone in milestones) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndMilestone(child.id, milestone.id);
        if (decision == null || decision.decision < 1) {
          return false;
        }
      }
    }
    if (vaccines != null) {
      for (var vaccine in vaccines) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndVaccine(child.id, vaccine.id);
        if (decision == null || decision.decision < 1) {
          return false;
        }
      }
    }
    return true;
  }

  Future<bool> checkIfAllTakenUntilToday(ChildModel child) async {
    int months = monthsFromBdCalculator(child);
    if (months <= 1) return true;

    List<MilestoneItem>? milestones =
        await milestoneRepository.getMilestonesUntilMonth(months);

    List<Vaccine>? vaccines =
        await vaccineRepository.getVaccinesUntilMonth(months);

    if (milestones != null) {
      for (var milestone in milestones) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndMilestone(child.id, milestone.id);
        if (decision == null || decision.decision < 1) {
          return false;
        }
      }
    }
    if (vaccines != null) {
      for (var vaccine in vaccines) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndVaccine(child.id, vaccine.id);
        if (decision == null || decision.decision < 1) {
          return false;
        }
      }
    }
    return true;
  }

  Future<bool> checkIfAlertDoctor(ChildModel child) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the saved action date
    String? savedDate = prefs.getString('lastAlertDoctoreDate');

    // If no date is saved, consider it as not within 5 days
    if (savedDate != null) {
      // Parse the saved date
      DateTime actionDate = DateTime.parse(savedDate);

      // Calculate the difference in days
      int daysDifference = DateTime.now().difference(actionDate).inDays;

      // Check if the action was initiated within the last 5 days
      if (daysDifference < 5) {
        return false;
      }
    }

    DaoResponse daoResponse = await decisionRepository.getDecisionsByAge(child);
    List<DecisionModel> listOfDecisions = daoResponse.item1;
    int i = 0;
    for (var dec in listOfDecisions) {
      if (dec.decision > 1) i++;
    }
    return i > 1;
  }

  Future<int> getPeriod(DecisionModel decision) async {
    if (decision.milestoneId > 0) {
      MilestoneItem? milestoneItem =
          await milestoneRepository.getMilestoneByID(decision.milestoneId);
      if (milestoneItem != null) return milestoneItem.period;
    } else {
      Vaccine? vaccine =
          await vaccineRepository.getVaccineByID(decision.vaccineId);
      if (vaccine != null) return vaccine.period;
    }
    return 0;
  }

  Future<int> getEndingAge(DecisionModel decision) async {
    if (decision.milestoneId > 0) {
      MilestoneItem? milestoneItem =
          await milestoneRepository.getMilestoneByID(decision.milestoneId);
      if (milestoneItem != null) return milestoneItem.endingAge;
    } else {
      Vaccine? vaccine =
          await vaccineRepository.getVaccineByID(decision.vaccineId);
      if (vaccine != null) return vaccine.endingAge;
    }
    return 0;
  }

  Future stopWeeklyNotifications(int childId) async {
    ChildModel? child = await childRepository.getChildByID(childId);
    if (child != null) {
      int period = periodCalculator(child).id;
      List<NotificationModel> notifications = await notificationRepository
          .getNotificationsByChildIdAndPeriod(childId, period);
      NotificationService _notificationService = NotificationService();

      for (var notification in notifications) {
        if (notification.id != null) {
          notificationRepository.deleteNotificationById(notification.id!);
          _notificationService.cancelNotifications(notification.id!);
        }
      }
      return true;
    }
    return false;
  }

  Future stopWeeklyNotificationsByMonth(int childId) async {
    ChildModel? child = await childRepository.getChildByID(childId);
    if (child != null) {
      int months = monthsFromBdCalculator(child);
      List<NotificationModel> notifications = await notificationRepository
          .getNotificationsByChildIdAndMonth(childId, months);
      NotificationService _notificationService = NotificationService();

      for (var notification in notifications) {
        if (notification.id != null) {
          notificationRepository.deleteNotificationById(notification.id!);
          _notificationService.cancelNotifications(notification.id!);
        }
      }
      return true;
    }
    return false;
  }

  // void updateDecisionsOnBackend(
  //     UploadDecisionsEvent event, Emitter<DecisionState> emit) async {
  //   emit(UploadingDecisionState());

  //   List<ChildModel> children = await childRepository.getAllChildren();
  //   List<MilestoneItem> milestones =
  //       await milestoneRepository.getAllMilestones();

  //   for (var child in children) {
  //     List data = [];
  //     // List<DecisionModel> decisions =
  //     //     await decisionRepository.getDecisionsByChild(child.id);
  //     for (var milestone in milestones) {
  //       DecisionModel? decisionModel = await decisionRepository
  //           .getDecisionByChildAndMilestone(child.id, milestone.id);

  //       if (decisionModel != null) {
  //         String decisionInWords = "";
  //         if (decisionModel.decision == 1) decisionInWords = "Yes";
  //         if (decisionModel.decision == 2) decisionInWords = "No";
  //         if (decisionModel.decision == 3) decisionInWords = "Maybe";

  //         data.add({
  //           "number": milestone.id,
  //           "question": milestone.description,
  //           "category": milestone.category,
  //           "startingAge": milestone.startingAge,
  //           "endingAge": milestone.endingAge,
  //           "period": milestone.period,
  //           "decision": decisionInWords,
  //         });
  //       }
  //     }

  //     // update child with these data
  //     print('data: ${data}');
  //   }

  // if (newDecisions.isNotEmpty) {
  //   final response = await http.post(Uri.parse(Urls.backendUrl + "test/"),
  //       body: {
  //         "decisions":
  //             newDecisions.map((item) => item.toJson()).toList().toString()
  //       });

  //   if (response.statusCode == 200) {
  //     for (var decision in newDecisions) {
  //       if (decision.uploaded) {
  //         continue;
  //       }
  //       decision.uploaded = true;
  //       decisionRepository.updateDecision(decision);
  //     }
  //   }
  // } else {
  //   emit(ErrorUploadingDecisionState(error: "response not 200"));
  // }
  // }

  // Future<String?> updateDecisionsOnBackend(
  //     List<DecisionModel> decisions) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString(SharedPrefKeys.accessToken);
  //   String? userID = prefs.getString(SharedPrefKeys.userID);
  //   if (token != null) {
  //     try {
  //       final response = await http.put(
  //         Uri.parse(Urls.backendUrl + Urls.createRatingUrl),
  //         headers: {
  //           "Authorization": "Bearer " + token,
  //         },
  //         body: {
  //           "id": ratingModel.ratingId,
  //           "rating": ratingModel.rating,
  //           "parent_id": userID,
  //         },
  //       );
  //       // print('response.body: ${response.body}');
  //       if (response.statusCode == 200) {
  //         return null;
  //       } else {
  //         return "response not 200";
  //       }
  //     } catch (e) {
  //       return "connection failed";
  //     }
  //   }
  //   return "token not available";
  // }
}
