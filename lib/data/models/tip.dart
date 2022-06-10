// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TipModel {
  int id;
  String title;
  String body;
  int startingWeek;
  int endingWeek;
  TipModel({
    required this.id,
    required this.title,
    required this.body,
    required this.startingWeek,
    required this.endingWeek,
  });

  TipModel copyWith({
    int? id,
    String? title,
    String? body,
    int? startingWeek,
    int? endingWeek,
  }) {
    return TipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      startingWeek: startingWeek ?? this.startingWeek,
      endingWeek: endingWeek ?? this.endingWeek,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'startingWeek': startingWeek,
      'endingWeek': endingWeek,
    };
  }

  factory TipModel.fromMap(Map<String, dynamic> map) {
    return TipModel(
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      startingWeek: map['startingWeek'] as int,
      endingWeek: map['endingWeek'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TipModel.fromJson(String source) =>
      TipModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TipModel(id: $id, title: $title, body: $body, startingWeek: $startingWeek, endingWeek: $endingWeek)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TipModel &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.startingWeek == startingWeek &&
        other.endingWeek == endingWeek;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        startingWeek.hashCode ^
        endingWeek.hashCode;
  }
}
