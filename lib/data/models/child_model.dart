// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

ChildModel childModelFromJson(String str) =>
    ChildModel.fromJson(json.decode(str));

String childModelToJson(ChildModel data) => json.encode(data.toJson());

class ChildModel {
  int id;
  String name;
  DateTime date_of_birth;
  String image_path;
  String gender;
  double pregnancy_duration;

  ChildModel({
    required this.id,
    required this.name,
    required this.date_of_birth,
    required this.image_path,
    required this.gender,
    required this.pregnancy_duration,
  });

  ChildModel copyWith({
    int? id,
    String? name,
    DateTime? date_of_birth,
    String? image_path,
    String? gender,
    double? pregnancy_duration,
  }) {
    return ChildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      image_path: image_path ?? this.image_path,
      gender: gender ?? this.gender,
      pregnancy_duration: pregnancy_duration ?? this.pregnancy_duration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'date_of_birth': date_of_birth.millisecondsSinceEpoch,
      'image_path': image_path,
      'gender': gender,
      'pregnancy_duration': pregnancy_duration,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map) {
    return ChildModel(
      id: map['id'] as int,
      name: map['name'] as String,
      date_of_birth:
          DateTime.fromMillisecondsSinceEpoch(map['date_of_birth'] as int),
      image_path: map['image_path'] as String,
      gender: map['gender'] as String,
      pregnancy_duration: map['pregnancy_duration'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChildModel.fromJson(String source) =>
      ChildModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChildModel(id: $id, name: $name, date_of_birth: $date_of_birth, image_path: $image_path, gender: $gender, pregnancy_duration: $pregnancy_duration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChildModel &&
        other.id == id &&
        other.name == name &&
        other.date_of_birth == date_of_birth &&
        other.image_path == image_path &&
        other.gender == gender &&
        other.pregnancy_duration == pregnancy_duration;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        date_of_birth.hashCode ^
        image_path.hashCode ^
        gender.hashCode ^
        pregnancy_duration.hashCode;
  }
}
