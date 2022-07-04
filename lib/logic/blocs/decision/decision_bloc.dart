import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/repositories/decision_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'decision_event.dart';
part 'decision_state.dart';

class DecisionBloc extends Bloc<DecisionEvent, DecisionState> {
  final DecisionRepository decisionRepository;

  DecisionBloc({required this.decisionRepository})
      : super(InitialDecisionState()) {
    on<AddDecisionEvent>(addDecision);
    on<GetAllDecisionsEvent>(getAllDecisions);
    on<DeleteAllDecisionsEvent>(deleteAllDecisions);

    on<GetDecisionEvent>(getDecision);
    on<GetDecisionsByAgeEvent>(getByAge);
    on<GetDecisionByChildAndMilestoneEvent>(getByChildAndMilestone);
  }

  void addDecision(AddDecisionEvent event, Emitter<DecisionState> emit) async {
    emit(AddingDecisionState());
    DaoResponse<bool, int> daoResponse =
        await decisionRepository.insertDecision(event.decision);
    if (daoResponse.item1) {
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
        await decisionRepository.getDecisionByID(event.decision_id);
    if (decision != null) {
      emit(DecisionLoadedState(decision));
    } else {
      emit(DecisionLoadingErrorState());
    }
  }

  void getByAge(
      GetDecisionsByAgeEvent event, Emitter<DecisionState> emit) async {
    emit(LoadingDecisionsByAgeState());
    DaoResponse<List<DecisionModel>, int> daoResponse = await decisionRepository
        .getDecisionsByAge(event.dateOfBirth, event.childId);
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
}
