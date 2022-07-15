// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationModel {
  int? id;
  String title;
  String body;
  DateTime issuedAt;
  bool opened;
  bool dismissed;
  String route;
  int period;
  int childId;
  int? milestoneId;
  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.issuedAt,
    required this.opened,
    required this.dismissed,
    required this.route,
    required this.period,
    required this.childId,
    this.milestoneId,
  });

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? issuedAt,
    bool? opened,
    bool? dismissed,
    String? route,
    int? period,
    int? childId,
    int? milestoneId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      issuedAt: issuedAt ?? this.issuedAt,
      opened: opened ?? this.opened,
      dismissed: dismissed ?? this.dismissed,
      route: route ?? this.route,
      period: period ?? this.period,
      childId: childId ?? this.childId,
      milestoneId: milestoneId ?? this.milestoneId,
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
      'route': route,
      'period': period,
      'childId': childId,
      'milestoneId': milestoneId,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] as String,
      body: map['body'] as String,
      issuedAt: DateTime.fromMillisecondsSinceEpoch(map['issuedAt'] as int),
      opened: map['opened'] == 1,
      dismissed: map['dismissed'] == 1,
      route: map['route'] as String,
      period: map['period'] as int,
      childId: map['childId'] as int,
      milestoneId:
          map['milestoneId'] != null ? map['milestoneId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, body: $body, issuedAt: $issuedAt, opened: $opened, dismissed: $dismissed, route: $route, period: $period, childId: $childId, milestoneId: $milestoneId)';
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
        other.route == route &&
        other.period == period &&
        other.childId == childId &&
        other.milestoneId == milestoneId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        issuedAt.hashCode ^
        opened.hashCode ^
        dismissed.hashCode ^
        route.hashCode ^
        period.hashCode ^
        childId.hashCode ^
        milestoneId.hashCode;
  }
}
