// ignore_for_file: file_names
import 'package:bloc/bloc.dart';
import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/data/models/vaccine.dart';
import 'package:child_milestone/data/repositories/decision_repository.dart';
import 'package:child_milestone/data/repositories/milestone_repository.dart';
import 'package:child_milestone/data/repositories/vaccine_repository.dart';
import 'package:child_milestone/logic/shared/functions.dart';

class AllPreviousDecisionTakenCubit extends Cubit<Map<int, allTaken>> {
  final MilestoneRepository milestoneRepository;
  final VaccineRepository vaccineRepository;
  final DecisionRepository decisionRepository;
  AllPreviousDecisionTakenCubit(
      {required this.milestoneRepository,
      required this.vaccineRepository,
      required this.decisionRepository,
      Map<int, allTaken> initialState = const {}})
      : super(initialState);

  void checkIfAllTaken(ChildModel child) async {
    int period = periodCalculator(child).id;
    if (period <= 1)
      emit({child.id: allTaken(milestones: true, vaccines: true)});

    Map<int, allTaken> newState = Map.from(state);

    List<MilestoneItem>? milestones =
        await milestoneRepository.getMilestonesUntilPeriod(period - 1);

    List<Vaccine>? vaccines =
        await vaccineRepository.getVaccinesUntilPeriod(period - 1);

    bool allMilestonesTaken = true;
    bool allVaccinesTaken = true;

    if (milestones != null) {
      for (var milestone in milestones) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndMilestone(child.id, milestone.id);
        if (decision == null || decision.decision < 1) {
          allMilestonesTaken = false;
          break;
        }
      }
    }
    if (vaccines != null) {
      for (var vaccine in vaccines) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndVaccine(child.id, vaccine.id);
        if (decision == null || decision.decision < 1) {
          allVaccinesTaken = false;
          break;
        }
      }
    }
    newState[child.id] =
        allTaken(milestones: allMilestonesTaken, vaccines: allVaccinesTaken);
    emit(newState);
  }
}
