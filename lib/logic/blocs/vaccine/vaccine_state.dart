part of 'vaccine_bloc.dart';

@immutable
abstract class VaccineState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialVaccineState extends VaccineState {}

class AddingVaccineState extends VaccineState {}

class AddedVaccineState extends VaccineState {}

class VaccineLoadingState extends VaccineState {}

class VaccineLoadingErrorState extends VaccineState {}

class VaccineLoadedState extends VaccineState {
  final Vaccine vaccine;

  VaccineLoadedState(this.vaccine);

  @override
  List<Object?> get props => [vaccine];
}

class AllVaccinesLoadingState extends VaccineState {}

class AllVaccinesLoadingErrorState extends VaccineState {}

class AllVaccinesLoadedState extends VaccineState {
  final List<Vaccine> vaccines;

  AllVaccinesLoadedState(this.vaccines);

  @override
  List<Object?> get props => [vaccines];
}

class DeleteingAllVaccinesState extends VaccineState {}

class DeletedAllVaccinesState extends VaccineState {}

class VaccineErrorState extends VaccineState {
  final String error;

  VaccineErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class LoadingVaccinesWithDecisionsByAgeState extends VaccineState {}

class ErrorLoadingVaccinesWithDecisionsByAgeState extends VaccineState {}

class LoadedVaccinesWithDecisionsByAgeState extends VaccineState {
  final List<VaccineWithDecision> items;

  LoadedVaccinesWithDecisionsByAgeState(this.items);

  @override
  List<Object?> get props => [items];
}

class LoadingVaccinesWithDecisionsByPeriodState extends VaccineState {}

class ErrorLoadingVaccinesWithDecisionsByPeriodState extends VaccineState {}

class LoadedVaccinesWithDecisionsByPeriodState extends VaccineState {
  final List<VaccineWithDecision> items;

  LoadedVaccinesWithDecisionsByPeriodState(this.items);

  @override
  List<Object?> get props => [items];
}

class LoadingVaccinesWithDecisionsByChildState extends VaccineState {}

class ErrorLoadingVaccinesWithDecisionsByChildState extends VaccineState {}

class LoadedVaccinesWithDecisionsByChildState extends VaccineState {
  final List<VaccineWithDecision> items;
  final int period;

  LoadedVaccinesWithDecisionsByChildState(this.items, this.period);

  @override
  List<Object?> get props => [items, period];
}

class LoadingVaccinesForSummaryState extends VaccineState {}

class ErrorLoadingVaccinesForSummaryState extends VaccineState {}

class LoadedVaccinesForSummaryState extends VaccineState {
  final List<VaccineWithDecision> items;
  final int period;

  LoadedVaccinesForSummaryState(this.items, this.period);

  @override
  List<Object?> get props => [items, period];
}
