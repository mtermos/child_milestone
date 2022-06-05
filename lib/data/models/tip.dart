// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TipModel {
  int id;
  String title;
  String body;
  int starting_week;
  int ending_week;
  TipModel({
    required this.id,
    required this.title,
    required this.body,
    required this.starting_week,
    required this.ending_week,
  });
  

  TipModel copyWith({
    int? id,
    String? title,
    String? body,
    int? starting_week,
    int? ending_week,
  }) {
    return TipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      starting_week: starting_week ?? this.starting_week,
      ending_week: ending_week ?? this.ending_week,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'starting_week': starting_week,
      'ending_week': ending_week,
    };
  }

  factory TipModel.fromMap(Map<String, dynamic> map) {
    return TipModel(
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      starting_week: map['starting_week'] as int,
      ending_week: map['ending_week'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TipModel.fromJson(String source) => TipModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TipModel(id: $id, title: $title, body: $body, starting_week: $starting_week, ending_week: $ending_week)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TipModel &&
      other.id == id &&
      other.title == title &&
      other.body == body &&
      other.starting_week == starting_week &&
      other.ending_week == ending_week;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      body.hashCode ^
      starting_week.hashCode ^
      ending_week.hashCode;
  }
}
