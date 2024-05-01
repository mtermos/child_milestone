// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LogModel {
  int? id;
  String action; // 1: open app 2: open document 3: open notification
  String description;
  DateTime takenAt;
  bool uploaded;
  LogModel({
    this.id,
    required this.action,
    required this.description,
    required this.takenAt,
    this.uploaded = false,
  });

  LogModel copyWith({
    int? id,
    String? action,
    String? description,
    DateTime? takenAt,
    bool? uploaded,
  }) {
    return LogModel(
      id: id ?? this.id,
      action: action ?? this.action,
      description: description ?? this.description,
      takenAt: takenAt ?? this.takenAt,
      uploaded: uploaded ?? this.uploaded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'action': action,
      'description': description,
      'takenAt': takenAt.millisecondsSinceEpoch,
      'uploaded': uploaded ? 1 : 0,
    };
  }

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      id: map['id'] != null ? map['id'] as int : null,
      action: map['action'] as String,
      description: map['description'] as String,
      takenAt: DateTime.fromMillisecondsSinceEpoch(map['takenAt'] as int),
      uploaded: map['uploaded'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory LogModel.fromJson(String source) =>
      LogModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LogModel(id: $id, action: $action, description: $description, takenAt: $takenAt, uploaded: $uploaded)';
  }

  @override
  bool operator ==(covariant LogModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.action == action &&
        other.description == description &&
        other.takenAt == takenAt &&
        other.uploaded == uploaded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        action.hashCode ^
        description.hashCode ^
        takenAt.hashCode ^
        uploaded.hashCode;
  }
}
