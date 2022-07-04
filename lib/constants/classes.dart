// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/milestone_item.dart';

class MilestoneWithDecision {
  MilestoneItem milestoneItem;
  DecisionModel decision;
  MilestoneWithDecision({
    required this.milestoneItem,
    required this.decision,
  });
}
