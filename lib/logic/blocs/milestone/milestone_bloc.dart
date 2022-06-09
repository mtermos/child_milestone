import 'dart:async';

import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/data/repositories/milestone_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part "milestone_event.dart";
part "milestone_state.dart";

class MilestoneBloc extends Bloc<MilestoneEvent, MilestoneState> {
  final MilestoneRepository milestoneRepository;

  MilestoneBloc({required this.milestoneRepository})
      : super(InitialMilestoneState()) {
    on<AddMilestoneEvent>(add_milestone);
    on<GetAllMilestonesEvent>(get_all_milestones);
    on<DeleteAllMilestonesEvent>(delete_all_milestones);

    on<GetMilestoneEvent>(get_milestone);
    on<GetMilestonesByAgeEvent>(get_by_age);
  }

  void add_milestone(
      AddMilestoneEvent event, Emitter<MilestoneState> emit) async {
    emit(AddingMilestoneState());
    await milestoneRepository.insertMilestone(event.milestone);
    emit(AddedMilestoneState());
  }

  void get_all_milestones(
      GetAllMilestonesEvent event, Emitter<MilestoneState> emit) async {
    emit(AllMilestonesLoadingState());
    // await milestoneRepository.deleteAllMilestones();
    List<MilestoneItem>? milestones =
        await milestoneRepository.getAllMilestones();
    if (milestones != null)
      emit(AllMilestonesLoadedState(milestones));
    else
      emit(AllMilestonesLoadingErrorState());
  }

  void delete_all_milestones(
      DeleteAllMilestonesEvent event, Emitter<MilestoneState> emit) async {
    emit(DeleteingAllMilestonesState());
    await milestoneRepository.deleteAllMilestones();
    emit(DeletedAllMilestonesState());
  }

  void get_milestone(
      GetMilestoneEvent event, Emitter<MilestoneState> emit) async {
    emit(MilestoneLoadingState());
    MilestoneItem? milestone =
        await milestoneRepository.getMilestoneByID(event.milestone_id);
    if (milestone != null)
      emit(MilestoneLoadedState(milestone));
    else
      emit(MilestoneLoadingErrorState());
  }

  void get_by_age(
      GetMilestonesByAgeEvent event, Emitter<MilestoneState> emit) async {
    emit(LoadingMilestonesByAgeState());
    List<MilestoneItem>? milestones =
        await milestoneRepository.getMilestonesByAge(event.dateOfBirth);
    if (milestones != null)
      emit(LoadedMilestonesByAgeState(milestones));
    else
      emit(ErrorLoadingMilestonesByAgeState());
  }
}
