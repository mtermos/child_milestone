// ignore_for_file: file_names
import 'package:bloc/bloc.dart';
import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/data/repositories/decision_repository.dart';
import 'package:child_milestone/data/repositories/milestone_repository.dart';
import 'package:child_milestone/logic/shared/functions.dart';

class AllPreviousDecisionTakenCubit extends Cubit<Map<int, bool>> {
  final MilestoneRepository milestoneRepository;
  final DecisionRepository decisionRepository;
  AllPreviousDecisionTakenCubit(
      {required this.milestoneRepository,
      required this.decisionRepository,
      Map<int, bool> initialState = const {}})
      : super(initialState);

  void checkIfAllTaken(ChildModel child) async {
    int period = periodCalculator(child).id;
    if (period <= 1) emit({child.id: true});

    List<MilestoneWithDecision> items = [];
    List<MilestoneItem>? milestones =
        await milestoneRepository.getMilestonesUntilPeriod(period - 1);

    if (milestones != null) {
      Map<int, bool> newState = Map.from(state);
      for (var milestone in milestones) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndMilestone(child.id, milestone.id);
        if (decision == null || decision.decision < 1) {
          newState[child.id] = false;
          emit(newState);
          break;
        }
        newState[child.id] = true;
        emit(newState);
      }
    } else {
      emit({});
    }
  }
}
