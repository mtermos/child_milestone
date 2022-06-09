part of 'milestone_bloc.dart';

@immutable
abstract class MilestoneState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialMilestoneState extends MilestoneState {}

class AddingMilestoneState extends MilestoneState {}

class AddedMilestoneState extends MilestoneState {}

class MilestoneLoadingState extends MilestoneState {}

class MilestoneLoadingErrorState extends MilestoneState {}

class MilestoneLoadedState extends MilestoneState {
  final MilestoneItem milestone;

  MilestoneLoadedState(this.milestone);

  @override
  List<Object?> get props => [milestone];
}

class AllMilestonesLoadingState extends MilestoneState {}

class AllMilestonesLoadingErrorState extends MilestoneState {}

class AllMilestonesLoadedState extends MilestoneState {
  final List<MilestoneItem> milestones;

  AllMilestonesLoadedState(this.milestones);

  @override
  List<Object?> get props => [milestones];
}

class DeleteingAllMilestonesState extends MilestoneState {}

class DeletedAllMilestonesState extends MilestoneState {}

class MilestoneErrorState extends MilestoneState {
  final String error;

  MilestoneErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class LoadingMilestonesByAgeState extends MilestoneState {}

class ErrorLoadingMilestonesByAgeState extends MilestoneState {}

class LoadedMilestonesByAgeState extends MilestoneState {
  final List<MilestoneItem> milestones;

  LoadedMilestonesByAgeState(this.milestones);

  @override
  List<Object?> get props => [milestones];
}