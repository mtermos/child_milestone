// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Vaccine {
  int id;
  String name;
  String description;
  int period;
  int startingAge;
  int endingAge;
  Vaccine({
    required this.id,
    required this.name,
    required this.description,
    required this.period,
    required this.startingAge,
    required this.endingAge,
  });

  Vaccine copyWith({
    int? id,
    String? name,
    String? description,
    int? period,
    int? startingAge,
    int? endingAge,
  }) {
    return Vaccine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      period: period ?? this.period,
      startingAge: startingAge ?? this.startingAge,
      endingAge: endingAge ?? this.endingAge,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'period': period,
      'startingAge': startingAge,
      'endingAge': endingAge,
    };
  }

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      period: map['period'] as int,
      startingAge: map['startingAge'] as int,
      endingAge: map['endingAge'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Vaccine.fromJson(String source) =>
      Vaccine.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Vaccine(id: $id, name: $name, description: $description, period: $period, startingAge: $startingAge, endingAge: $endingAge)';
  }

  @override
  bool operator ==(covariant Vaccine other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.period == period &&
        other.startingAge == startingAge &&
        other.endingAge == endingAge;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        period.hashCode ^
        startingAge.hashCode ^
        endingAge.hashCode;
  }
}
