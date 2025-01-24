import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/vaccine.dart';
import 'package:child_milestone/data/repositories/decision_repository.dart';
import 'package:child_milestone/data/repositories/vaccine_repository.dart';
import 'package:child_milestone/logic/shared/functions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'vaccine_event.dart';
part 'vaccine_state.dart';

class VaccineBloc extends Bloc<VaccineEvent, VaccineState> {
  final VaccineRepository vaccineRepository;
  final DecisionRepository decisionRepository;

  VaccineBloc(
      {required this.vaccineRepository, required this.decisionRepository})
      : super(InitialVaccineState()) {
    on<AddVaccineEvent>(addVaccine);
    on<GetAllVaccinesEvent>(getAllVaccines);
    on<DeleteAllVaccinesEvent>(deleteAllVaccines);

    on<GetVaccineEvent>(getVaccine);
    on<GetVaccinesWithDecisionsByAgeEvent>(getByAge);
    on<GetVaccinesWithDecisionsByPeriodEvent>(getByPeriod);
    on<GetVaccinesWithDecisionsByChildEvent>(getByChild);
    on<GetVaccinesForSummaryEvent>(getForSummary);
  }

  void addVaccine(AddVaccineEvent event, Emitter<VaccineState> emit) async {
    emit(AddingVaccineState());
    try {
      await vaccineRepository.insertVaccine(event.vaccine);
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(AddedVaccineState());
  }

  void getAllVaccines(
      GetAllVaccinesEvent event, Emitter<VaccineState> emit) async {
    emit(AllVaccinesLoadingState());
    // await vaccineRepository.deleteAllVaccines();
    List<Vaccine>? vaccines = await vaccineRepository.getAllVaccines();
    if (vaccines != null) {
      emit(AllVaccinesLoadedState(vaccines));
    } else {
      emit(AllVaccinesLoadingErrorState());
    }
  }

  void deleteAllVaccines(
      DeleteAllVaccinesEvent event, Emitter<VaccineState> emit) async {
    emit(DeleteingAllVaccinesState());
    await vaccineRepository.deleteAllVaccines();
    emit(DeletedAllVaccinesState());
  }

  void getVaccine(GetVaccineEvent event, Emitter<VaccineState> emit) async {
    emit(VaccineLoadingState());
    Vaccine? vaccine = await vaccineRepository.getVaccineByID(event.vaccineId);
    if (vaccine != null) {
      emit(VaccineLoadedState(vaccine));
    } else {
      emit(VaccineLoadingErrorState());
    }
  }

  void getByAge(GetVaccinesWithDecisionsByAgeEvent event,
      Emitter<VaccineState> emit) async {
    emit(LoadingVaccinesWithDecisionsByAgeState());
    List<VaccineWithDecision> items = [];
    List<Vaccine>? vaccines =
        await vaccineRepository.getVaccinesByAge(event.child);

    if (vaccines != null) {
      for (var vaccine in vaccines) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndVaccine(event.child.id, vaccine.id);
        items.add(VaccineWithDecision(
            vaccine: vaccine,
            decision: decision ??
                DecisionModel(
                    childId: event.child.id,
                    milestoneId: 0,
                    vaccineId: vaccine.id,
                    decision: -1,
                    takenAt: DateTime.now())));
      }

      emit(LoadedVaccinesWithDecisionsByAgeState(items));
    } else {
      emit(ErrorLoadingVaccinesWithDecisionsByAgeState());
    }
  }

  void getByPeriod(GetVaccinesWithDecisionsByPeriodEvent event,
      Emitter<VaccineState> emit) async {
    emit(LoadingVaccinesWithDecisionsByPeriodState());
    List<VaccineWithDecision> items = [];
    List<Vaccine>? vaccines =
        await vaccineRepository.getVaccinesByPeriod(event.periodId);

    if (vaccines != null) {
      for (var vaccine in vaccines) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndVaccine(event.child.id, vaccine.id);
        items.add(VaccineWithDecision(
            vaccine: vaccine,
            decision: decision ??
                DecisionModel(
                    childId: event.child.id,
                    milestoneId: 0,
                    vaccineId: vaccine.id,
                    decision: -1,
                    takenAt: DateTime.now())));
      }

      emit(LoadedVaccinesWithDecisionsByPeriodState(items));
    } else {
      emit(ErrorLoadingVaccinesWithDecisionsByPeriodState());
    }
  }

  void getByChild(GetVaccinesWithDecisionsByChildEvent event,
      Emitter<VaccineState> emit) async {
    emit(LoadingVaccinesWithDecisionsByChildState());
    List<VaccineWithDecision> items = [];
    List<Vaccine>? vaccines = await vaccineRepository.getAllVaccines();

    if (vaccines != null) {
      for (var vaccine in vaccines) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndVaccine(event.child.id, vaccine.id);
        items.add(VaccineWithDecision(
            vaccine: vaccine,
            decision: decision ??
                DecisionModel(
                    childId: event.child.id,
                    milestoneId: 0,
                    vaccineId: vaccine.id,
                    decision: -1,
                    takenAt: DateTime.now())));
      }

      int period = periodCalculator(event.child).id;

      emit(LoadedVaccinesWithDecisionsByChildState(items, period));
    } else {
      emit(ErrorLoadingVaccinesWithDecisionsByChildState());
    }
  }

  void getForSummary(
      GetVaccinesForSummaryEvent event, Emitter<VaccineState> emit) async {
    emit(LoadingVaccinesForSummaryState());
    List<VaccineWithDecision> items = [];
    List<Vaccine>? vaccines =
        await vaccineRepository.getVaccinesByPeriod(event.periodId);

    if (vaccines != null) {
      for (var vaccine in vaccines) {
        DecisionModel? decision = await decisionRepository
            .getDecisionByChildAndVaccine(event.child.id, vaccine.id);
        items.add(VaccineWithDecision(
            vaccine: vaccine,
            decision: decision ??
                DecisionModel(
                    childId: event.child.id,
                    milestoneId: 0,
                    vaccineId: vaccine.id,
                    decision: -1,
                    takenAt: DateTime.now())));
      }

      int period = periodCalculator(event.child).id;

      emit(LoadedVaccinesForSummaryState(items, period));
    } else {
      emit(ErrorLoadingVaccinesForSummaryState());
    }
  }
}
