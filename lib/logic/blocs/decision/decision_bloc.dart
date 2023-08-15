import 'dart:async';

import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/data/models/notification.dart';
import 'package:child_milestone/data/repositories/child_repository.dart';
import 'package:child_milestone/data/repositories/decision_repository.dart';
import 'package:child_milestone/data/repositories/milestone_repository.dart';
import 'package:child_milestone/data/repositories/notification_repository.dart';
import 'package:child_milestone/logic/shared/functions.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:child_milestone/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';

part 'decision_event.dart';
part 'decision_state.dart';

class DecisionBloc extends Bloc<DecisionEvent, DecisionState> {
  final DecisionRepository decisionRepository;
  final NotificationRepository notificationRepository;
  final ChildRepository childRepository;
  final MilestoneRepository milestoneRepository;
  final ChildBloc childBloc;
  late final StreamSubscription childBlocSubscription;

  DecisionBloc({
    required this.decisionRepository,
    required this.notificationRepository,
    required this.childRepository,
    required this.milestoneRepository,
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
    DaoResponse<bool, int> daoResponse =
        await decisionRepository.insertDecision(event.decision);

    bool allTaken = await checkIfAllDecisions(event.decision.childId);
    if (allTaken) {
      await stopWeeklyNotifications(event.decision.childId);
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
    List<DecisionModel>? decisions = await decisionRepository.getAllDecisions();
    if (decisions != null) {
      emit(AllDecisionsLoadedState(decisions));
    } else {
      emit(AllDecisionsLoadingErrorState());
    }
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
        await decisionRepository.getDecisionsByAge(event.child, event.child.id);
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

  Future<bool> checkIfAllDecisions(int childId) async {
    List<DecisionModel> daoResponse =
        await decisionRepository.getDecisionsByChild(childId);
    for (var dec in daoResponse) {
      if (dec.decision < 1) return false;
    }
    return true;
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
