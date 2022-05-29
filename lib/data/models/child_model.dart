// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

ChildModel childModelFromJson(String str) =>
    ChildModel.fromJson(json.decode(str));

String childModelToJson(ChildModel data) => json.encode(data.toJson());

class ChildModel {
  String name;
  DateTime date_of_birth;
  String image_path;
  String child_id;
  String gender;
  double pregnancy_duration;

  ChildModel({
    required this.name,
    required this.date_of_birth,
    required this.image_path,
    required this.child_id,
    required this.gender,
    required this.pregnancy_duration,
  });

  @override
  String toString() {
    return 'ChildModel(name: $name, date_of_birth: $date_of_birth, image_path: $image_path, child_id: $child_id, gender: $gender, pregnancy_duration: $pregnancy_duration)';
  }

  ChildModel copyWith({
    String? name,
    DateTime? date_of_birth,
    String? image_path,
    String? id,
    String? gender,
    double? pregnancy_duration,
  }) {
    return ChildModel(
      name: name ?? this.name,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      image_path: image_path ?? this.image_path,
      child_id: id ?? this.child_id,
      gender: gender ?? this.gender,
      pregnancy_duration: pregnancy_duration ?? this.pregnancy_duration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'date_of_birth': date_of_birth.millisecondsSinceEpoch,
      'image_path': image_path,
      'child_id': child_id,
      'gender': gender,
      'pregnancy_duration': pregnancy_duration,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map) {
    return ChildModel(
      name: map['name'] as String,
      date_of_birth:
          DateTime.fromMillisecondsSinceEpoch(map['date_of_birth'] as int),
      image_path: map['image_path'] as String,
      child_id: map['child_id'] as String,
      gender: map['gender'] as String,
      pregnancy_duration: map['pregnancy_duration'] as double,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChildModel &&
        other.name == name &&
        other.date_of_birth == date_of_birth &&
        other.image_path == image_path &&
        other.child_id == child_id &&
        other.gender == gender &&
        other.pregnancy_duration == pregnancy_duration;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        date_of_birth.hashCode ^
        image_path.hashCode ^
        child_id.hashCode ^
        gender.hashCode ^
        pregnancy_duration.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory ChildModel.fromJson(String source) =>
      ChildModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
