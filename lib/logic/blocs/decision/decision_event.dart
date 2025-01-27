// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'decision_bloc.dart';

@immutable
abstract class DecisionEvent extends Equatable {
  const DecisionEvent();
  @override
  List<Object> get props => [];
}

class AddDecisionEvent extends DecisionEvent {
  final DecisionModel decision;
  final Function onSuccess;
  final AppLocalizations appLocalizations;

  const AddDecisionEvent({
    required this.decision,
    required this.onSuccess,
    required this.appLocalizations,
  });
}

class GetAllDecisionsEvent extends DecisionEvent {}

class DeleteAllDecisionsEvent extends DecisionEvent {}

class GetDecisionEvent extends DecisionEvent {
  final int decisionId;
  const GetDecisionEvent({required this.decisionId});
}

class GetDecisionsByChild extends DecisionEvent {
  final int childId;
  const GetDecisionsByChild({required this.childId});
}

class GetDecisionsByAgeEvent extends DecisionEvent {
  final ChildModel child;
  const GetDecisionsByAgeEvent({required this.child});
}

class GetDecisionByChildAndMilestoneEvent extends DecisionEvent {
  final int childId;
  final int milestoneId;
  const GetDecisionByChildAndMilestoneEvent(
      {required this.childId, required this.milestoneId});
}

class GetDecisionByChildAndVaccineEvent extends DecisionEvent {
  final int childId;
  final int vaccineId;
  const GetDecisionByChildAndVaccineEvent(
      {required this.childId, required this.vaccineId});
}

class UploadDecisionsEvent extends DecisionEvent {
  const UploadDecisionsEvent();
}
