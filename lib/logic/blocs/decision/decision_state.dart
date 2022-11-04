part of 'decision_bloc.dart';

@immutable
abstract class DecisionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialDecisionState extends DecisionState {}

class AddingDecisionState extends DecisionState {}

class AddedDecisionState extends DecisionState {
  final DecisionModel decision;

  AddedDecisionState(this.decision);

  @override
  List<Object?> get props => [decision];
}

class DecisionLoadingState extends DecisionState {}

class DecisionLoadingErrorState extends DecisionState {}

class DecisionLoadedState extends DecisionState {
  final DecisionModel decision;

  DecisionLoadedState(this.decision);

  @override
  List<Object?> get props => [decision];
}

class AllDecisionsLoadingState extends DecisionState {}

class AllDecisionsLoadingErrorState extends DecisionState {}

class AllDecisionsLoadedState extends DecisionState {
  final List<DecisionModel> decisions;

  AllDecisionsLoadedState(this.decisions);

  @override
  List<Object?> get props => [decisions];
}

class DeleteingAllDecisionsState extends DecisionState {}

class DeletedAllDecisionsState extends DecisionState {}

class DecisionErrorState extends DecisionState {
  final String error;

  DecisionErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class LoadingDecisionsByChildState extends DecisionState {}

class ErrorLoadingDecisionsByChildState extends DecisionState {}

class LoadedDecisionsByChildState extends DecisionState {
  final List<DecisionModel> decisions;

  LoadedDecisionsByChildState(this.decisions);

  @override
  List<Object?> get props => [decisions];
}

class LoadingDecisionsByAgeState extends DecisionState {}

class ErrorLoadingDecisionsByAgeState extends DecisionState {}

class LoadedDecisionsByAgeState extends DecisionState {
  final List<DecisionModel> decisions;
  final int milestonesLength;

  LoadedDecisionsByAgeState(this.decisions, this.milestonesLength);

  @override
  List<Object?> get props => [decisions, milestonesLength];
}

class LoadingDecisionByChildAndMilestoneState extends DecisionState {}

class ErrorLoadingDecisionByChildAndMilestoneState extends DecisionState {}

class LoadedDecisionByChildAndMilestoneState extends DecisionState {
  final DecisionModel decision;

  LoadedDecisionByChildAndMilestoneState(this.decision);

  @override
  List<Object?> get props => [decision];
}

class UploadingDecisionState extends DecisionState {}

class ErrorUploadingDecisionState extends DecisionState {
  final String error;
  ErrorUploadingDecisionState({
    required this.error,
  });
}

class UploadedDecisionState extends DecisionState {}
