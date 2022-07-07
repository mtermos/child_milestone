// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'milestone_bloc.dart';

@immutable
abstract class MilestoneEvent extends Equatable {
  const MilestoneEvent();
  @override
  List<Object> get props => [];
}

class AddMilestoneEvent extends MilestoneEvent {
  final MilestoneItem milestone;

  const AddMilestoneEvent({
    required this.milestone,
  });
}

class GetAllMilestonesEvent extends MilestoneEvent {}

class DeleteAllMilestonesEvent extends MilestoneEvent {}

class GetMilestoneEvent extends MilestoneEvent {
  final int milestoneId;
  const GetMilestoneEvent({required this.milestoneId});
}

class GetMilestonesWithDecisionsByAgeEvent extends MilestoneEvent {
  final ChildModel child;
  const GetMilestonesWithDecisionsByAgeEvent({required this.child});
}


class GetMilestonesWithDecisionsByChildEvent extends MilestoneEvent {
  final ChildModel child;
  const GetMilestonesWithDecisionsByChildEvent({required this.child});
}
