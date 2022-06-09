// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'milestone_bloc.dart';

@immutable
abstract class MilestoneEvent extends Equatable {
  const MilestoneEvent();
  @override
  List<Object> get props => [];
}

class AddMilestoneEvent extends MilestoneEvent {
  MilestoneItem milestone;

  AddMilestoneEvent({
    required this.milestone,
  });
}

class GetAllMilestonesEvent extends MilestoneEvent {}

class DeleteAllMilestonesEvent extends MilestoneEvent {}

class GetMilestoneEvent extends MilestoneEvent {
  int milestone_id;
  GetMilestoneEvent({required this.milestone_id});
}

class GetMilestonesByAgeEvent extends MilestoneEvent {
  DateTime dateOfBirth;
  GetMilestonesByAgeEvent({required this.dateOfBirth});
}
