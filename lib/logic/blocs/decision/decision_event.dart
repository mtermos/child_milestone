// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'decision_bloc.dart';

@immutable
abstract class DecisionEvent extends Equatable {
  const DecisionEvent();
  @override
  List<Object> get props => [];
}

class AddDecisionEvent extends DecisionEvent {
  DecisionModel decision;
  Function onSuccess;

  AddDecisionEvent({
    required this.decision,
    required this.onSuccess,
  });
}

class GetAllDecisionsEvent extends DecisionEvent {}

class DeleteAllDecisionsEvent extends DecisionEvent {}

class GetDecisionEvent extends DecisionEvent {
  int decision_id;
  GetDecisionEvent({required this.decision_id});
}

class GetDecisionsByChild extends DecisionEvent {
  int childId;
  GetDecisionsByChild({required this.childId});
}

class GetDecisionsByAgeEvent extends DecisionEvent {
  DateTime dateOfBirth;
  int childId;
  GetDecisionsByAgeEvent({required this.dateOfBirth, required this.childId});
}

class GetDecisionByChildAndMilestoneEvent extends DecisionEvent {
  int childId;
  int milestoneId;
  GetDecisionByChildAndMilestoneEvent(
      {required this.childId, required this.milestoneId});
}
