import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/data/repositories/decision_repository.dart';
import 'package:child_milestone/data/repositories/milestone_repository.dart';
import 'package:child_milestone/logic/shared/functions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part "milestone_event.dart";
part "milestone_state.dart";

class MilestoneBloc extends Bloc<MilestoneEvent, MilestoneState> {
  final MilestoneRepository milestoneRepository;
  final DecisionRepository decisionRepository;

  MilestoneBloc(
      {required this.milestoneRepository, required this.decisionRepository})
      : super(InitialMilestoneState()) {
    on<AddMilestoneEvent>(addMilestone);
    on<GetAllMilestonesEvent>(getAllMilestones);
    on<DeleteAllMilestonesEvent>(deleteAllMilestones);

    on<GetMilestoneEvent>(getMilestone);
    on<GetMilestonesWithDecisionsByAgeEvent>(getByAge);
    on<GetMilestonesWithDecisionsByChildEvent>(getByChild);
  }

  void addMilestone(
      AddMilestoneEvent event, Emitter<MilestoneState> emit) async {
    emit(AddingMilestoneState());
    await milestoneRepository.insertMilestone(event.milestone);
    emit(AddedMilestoneState());
  }

  void getAllMilestones(
      GetAllMilestonesEvent event, Emitter<MilestoneState> emit) async {
    emit(AllMilestonesLoadingState());
    // await milestoneRepository.deleteAllMilestones();
    List<MilestoneItem>? milestones =
        await milestoneRepository.getAllMilestones();
    if (milestones != null) {
      emit(AllMilestonesLoadedState(milestones));
    } else {
      emit(AllMilestonesLoadingErrorState());
    }
  }

  void deleteAllMilestones(
      DeleteAllMilestonesEvent event, Emitter<MilestoneState> emit) async {
    emit(DeleteingAllMilestonesState());
    await milestoneRepository.deleteAllMilestones();
    emit(DeletedAllMilestonesState());
  }

  void getMilestone(
      GetMilestoneEvent event, Emitter<MilestoneState> emit) async {
    emit(MilestoneLoadingState());
    MilestoneItem? milestone =
        await milestoneRepository.getMilestoneByID(event.milestoneId);
    if (milestone != null) {
      emit(MilestoneLoadedState(milestone));
    } else {
      emit(MilestoneLoadingErrorState());
    }
  }

  void getByAge(GetMilestonesWithDecisionsByAgeEvent event,
      Emitter<MilestoneState> emit) async {
    emit(LoadingMilestonesWithDecisionsByAgeState());
    List<MilestoneWithDecision> items = [];
    List<MilestoneItem>? milestones =
        await milestoneRepository.getMilestonesByAge(event.child.dateOfBirth);

    if (milestones != null) {
      for (var milestone in milestones) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndMilestone(event.child.id, milestone.id);
        items.add(MilestoneWithDecision(
            milestoneItem: milestone,
            decision: decision ??
                DecisionModel(
                    childId: event.child.id,
                    milestoneId: milestone.id,
                    decision: -1,
                    takenAt: DateTime.now())));
      }

      emit(LoadedMilestonesWithDecisionsByAgeState(items));
    } else {
      emit(ErrorLoadingMilestonesWithDecisionsByAgeState());
    }
  }

  void getByChild(GetMilestonesWithDecisionsByChildEvent event,
      Emitter<MilestoneState> emit) async {
    emit(LoadingMilestonesWithDecisionsByChildState());
    List<MilestoneWithDecision> items = [];
    List<MilestoneItem>? milestones =
        await milestoneRepository.getAllMilestones();

    if (milestones != null) {
      for (var milestone in milestones) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndMilestone(event.child.id, milestone.id);
        items.add(MilestoneWithDecision(
            milestoneItem: milestone,
            decision: decision ??
                DecisionModel(
                    childId: event.child.id,
                    milestoneId: milestone.id,
                    decision: -1,
                    takenAt: DateTime.now())));
      }

      int period = periodCalculator(event.child.dateOfBirth);

      emit(LoadedMilestonesWithDecisionsByChildState(items, period));
    } else {
      emit(ErrorLoadingMilestonesWithDecisionsByChildState());
    }
  }
}
