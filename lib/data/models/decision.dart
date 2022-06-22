// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DecisionModel {
  int? id;
  int childId;
  int milestoneId;
  int decision;
  DateTime takenAt;
  DecisionModel({
    this.id,
    required this.childId,
    required this.milestoneId,
    required this.decision,
    required this.takenAt,
  });

  DecisionModel copyWith({
    int? id,
    int? childId,
    int? milestoneId,
    int? decision,
    DateTime? takenAt,
  }) {
    return DecisionModel(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      milestoneId: milestoneId ?? this.milestoneId,
      decision: decision ?? this.decision,
      takenAt: takenAt ?? this.takenAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'childId': childId,
      'milestoneId': milestoneId,
      'decision': decision,
      'takenAt': takenAt.millisecondsSinceEpoch,
    };
  }

  factory DecisionModel.fromMap(Map<String, dynamic> map) {
    return DecisionModel(
      id: map['id'] != null ? map['id'] as int : null,
      childId: map['childId'] as int,
      milestoneId: map['milestoneId'] as int,
      decision: map['decision'] as int,
      takenAt: DateTime.fromMillisecondsSinceEpoch(map['takenAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory DecisionModel.fromJson(String source) => DecisionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DecisionModel(id: $id, childId: $childId, milestoneId: $milestoneId, decision: $decision, takenAt: $takenAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DecisionModel &&
      other.id == id &&
      other.childId == childId &&
      other.milestoneId == milestoneId &&
      other.decision == decision &&
      other.takenAt == takenAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      childId.hashCode ^
      milestoneId.hashCode ^
      decision.hashCode ^
      takenAt.hashCode;
  }
}
