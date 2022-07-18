// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DecisionModel {
  int? id;
  int childId;
  int milestoneId;
  int decision;
  bool uploaded;
  DateTime takenAt;
  DecisionModel({
    this.id,
    required this.childId,
    required this.milestoneId,
    required this.decision,
    required this.takenAt,
    this.uploaded = false,
  });

  DecisionModel copyWith({
    int? id,
    int? childId,
    int? milestoneId,
    int? decision,
    bool? uploaded,
    DateTime? takenAt,
  }) {
    return DecisionModel(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      milestoneId: milestoneId ?? this.milestoneId,
      decision: decision ?? this.decision,
      uploaded: uploaded ?? this.uploaded,
      takenAt: takenAt ?? this.takenAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'childId': childId,
      'milestoneId': milestoneId,
      'decision': decision,
      'uploaded': uploaded ? 1 : 0,
      'takenAt': takenAt.millisecondsSinceEpoch,
    };
  }

  factory DecisionModel.fromMap(Map<String, dynamic> map) {
    return DecisionModel(
      id: map['id'] != null ? map['id'] as int : null,
      childId: map['childId'] as int,
      milestoneId: map['milestoneId'] as int,
      decision: map['decision'] as int,
      uploaded: map['uploaded'] == 1,
      takenAt: DateTime.fromMillisecondsSinceEpoch(map['takenAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory DecisionModel.fromJson(String source) =>
      DecisionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DecisionModel(id: $id, childId: $childId, milestoneId: $milestoneId, decision: $decision, uploaded: $uploaded, takenAt: $takenAt)';
  }

  @override
  bool operator ==(covariant DecisionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.childId == childId &&
        other.milestoneId == milestoneId &&
        other.decision == decision &&
        other.uploaded == uploaded &&
        other.takenAt == takenAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        childId.hashCode ^
        milestoneId.hashCode ^
        decision.hashCode ^
        uploaded.hashCode ^
        takenAt.hashCode;
  }
}
