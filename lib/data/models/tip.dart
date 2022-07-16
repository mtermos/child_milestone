// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TipModel {
  int id;
  String title;
  String body;
  int period;
  TipModel({
    required this.id,
    required this.title,
    required this.body,
    required this.period,
  });

  TipModel copyWith({
    int? id,
    String? title,
    String? body,
    int? period,
  }) {
    return TipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      period: period ?? this.period,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'period': period,
    };
  }

  factory TipModel.fromMap(Map<String, dynamic> map) {
    return TipModel(
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      period: map['period'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TipModel.fromJson(String source) =>
      TipModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TipModel(id: $id, title: $title, body: $body, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TipModel &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.period == period;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ body.hashCode ^ period.hashCode;
  }
}
