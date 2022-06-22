// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:child_milestone/data/models/child_model.dart';

class NotificationModel {
  int id;
  String title;
  String body;
  DateTime issuedAt;
  bool opened;
  bool dismissed;
  int childId;
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.issuedAt,
    required this.opened,
    required this.dismissed,
    required this.childId,
  });

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? issuedAt,
    bool? opened,
    bool? dismissed,
    int? childId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      issuedAt: issuedAt ?? this.issuedAt,
      opened: opened ?? this.opened,
      dismissed: dismissed ?? this.dismissed,
      childId: childId ?? this.childId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'issuedAt': issuedAt.millisecondsSinceEpoch,
      'opened': opened ? 1 : 0,
      'dismissed': dismissed ? 1 : 0,
      'childId': childId,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      issuedAt: DateTime.fromMillisecondsSinceEpoch(map['issuedAt'] as int),
      opened: map['opened'] == 1,
      dismissed: map['dismissed'] == 1,
      childId: map['childId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, body: $body, issuedAt: $issuedAt, opened: $opened, dismissed: $dismissed, childId: $childId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.issuedAt == issuedAt &&
        other.opened == opened &&
        other.dismissed == dismissed &&
        other.childId == childId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        issuedAt.hashCode ^
        opened.hashCode ^
        dismissed.hashCode ^
        childId.hashCode;
  }
}
