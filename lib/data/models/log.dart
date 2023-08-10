// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LogModel {
  int? id;
  int type; // 1: open app 2: open document 3: open notification
  String name;
  DateTime takenAt;
  bool uploaded;
  LogModel({
    this.id,
    required this.type,
    required this.name,
    required this.takenAt,
    this.uploaded = false,
  });

  LogModel copyWith({
    int? id,
    int? type,
    String? name,
    DateTime? takenAt,
    bool? uploaded,
  }) {
    return LogModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      takenAt: takenAt ?? this.takenAt,
      uploaded: uploaded ?? this.uploaded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'name': name,
      'takenAt': takenAt.millisecondsSinceEpoch,
      'uploaded': uploaded ? 1 : 0,
    };
  }

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      id: map['id'] != null ? map['id'] as int : null,
      type: map['type'] as int,
      name: map['name'] as String,
      takenAt: DateTime.fromMillisecondsSinceEpoch(map['takenAt'] as int),
      uploaded: map['uploaded'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory LogModel.fromJson(String source) =>
      LogModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LogModel(id: $id, type: $type, name: $name, takenAt: $takenAt, uploaded: $uploaded)';
  }

  @override
  bool operator ==(covariant LogModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.name == name &&
        other.takenAt == takenAt &&
        other.uploaded == uploaded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        name.hashCode ^
        takenAt.hashCode ^
        uploaded.hashCode;
  }
}
