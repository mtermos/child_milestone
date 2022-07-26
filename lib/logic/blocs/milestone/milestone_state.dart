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

class LoadingMilestonesWithDecisionsByAgeState extends MilestoneState {}

class ErrorLoadingMilestonesWithDecisionsByAgeState extends MilestoneState {}

class LoadedMilestonesWithDecisionsByAgeState extends MilestoneState {
  final List<MilestoneWithDecision> items;

  LoadedMilestonesWithDecisionsByAgeState(this.items);

  @override
  List<Object?> get props => [items];
}

class LoadingMilestonesWithDecisionsByChildState extends MilestoneState {}

class ErrorLoadingMilestonesWithDecisionsByChildState extends MilestoneState {}

class LoadedMilestonesWithDecisionsByChildState extends MilestoneState {
  final List<MilestoneWithDecision> items;
  final int period;

  LoadedMilestonesWithDecisionsByChildState(this.items, this.period);

  @override
  List<Object?> get props => [items, period];
}

class LoadingMilestonesForSummaryState extends MilestoneState {}

class ErrorLoadingMilestonesForSummaryState extends MilestoneState {}

class LoadedMilestonesForSummaryState extends MilestoneState {
  final List<MilestoneWithDecision> items;
  final int period;

  LoadedMilestonesForSummaryState(this.items, this.period);

  @override
  List<Object?> get props => [items, period];
}
