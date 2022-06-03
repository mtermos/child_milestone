// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:child_milestone/data/models/child_model.dart';

class NotificationModel {
  int id;
  String title;
  String body;
  DateTime issued_time;
  bool opened;
  ChildModel child;
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.issued_time,
    required this.opened,
    required this.child,
  });
  

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? issued_time,
    bool? opened,
    ChildModel? child,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      issued_time: issued_time ?? this.issued_time,
      opened: opened ?? this.opened,
      child: child ?? this.child,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'issued_time': issued_time.millisecondsSinceEpoch,
      'opened': opened,
      'child': child.toMap(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      issued_time: DateTime.fromMillisecondsSinceEpoch(map['issued_time'] as int),
      opened: map['opened'] as bool,
      child: ChildModel.fromMap(map['child'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, body: $body, issued_time: $issued_time, opened: $opened, child: $child)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NotificationModel &&
      other.id == id &&
      other.title == title &&
      other.body == body &&
      other.issued_time == issued_time &&
      other.opened == opened &&
      other.child == child;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      body.hashCode ^
      issued_time.hashCode ^
      opened.hashCode ^
      child.hashCode;
  }
}
