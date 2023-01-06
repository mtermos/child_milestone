// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/data/models/notification.dart';

class MilestoneWithDecision {
  MilestoneItem milestoneItem;
  DecisionModel decision;
  MilestoneWithDecision({
    required this.milestoneItem,
    required this.decision,
  });
}

class NotificationWithChildAndMilestone {
  NotificationModel notification;
  ChildModel child;
  MilestoneItem? milestone;
  NotificationWithChildAndMilestone({
    required this.notification,
    required this.child,
    this.milestone,
  });
}

class Period {
  int id;
  String arabicName;
  String arabicNameNumbers;
  Period({
    required this.id,
    required this.arabicName,
    required this.arabicNameNumbers,
  });
}
