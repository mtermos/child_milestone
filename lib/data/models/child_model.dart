// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

ChildModel childModelFromJson(String str) =>
    ChildModel.fromJson(json.decode(str));

String childModelToJson(ChildModel data) => json.encode(data.toJson());

class ChildModel {
  int id;
  String name;
  DateTime dateOfBirth;
  String imagePath;
  String gender;
  int pregnancyDuration;
  bool uploaded;
  String? idBackend;
  ChildModel({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.imagePath,
    required this.gender,
    required this.pregnancyDuration,
    this.uploaded = false,
    this.idBackend,
  });

  ChildModel copyWith({
    int? id,
    String? name,
    DateTime? dateOfBirth,
    String? imagePath,
    String? gender,
    int? pregnancyDuration,
    bool? uploaded,
    String? idBackend,
  }) {
    return ChildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      imagePath: imagePath ?? this.imagePath,
      gender: gender ?? this.gender,
      pregnancyDuration: pregnancyDuration ?? this.pregnancyDuration,
      uploaded: uploaded ?? this.uploaded,
      idBackend: idBackend ?? this.idBackend,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'imagePath': imagePath,
      'gender': gender,
      'pregnancyDuration': pregnancyDuration,
      'uploaded': uploaded ? 1 : 0,
      'idBackend': idBackend,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map) {
    return ChildModel(
      id: map['id'] as int,
      name: map['name'] as String,
      dateOfBirth:
          DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
      imagePath: map['imagePath'] as String,
      gender: map['gender'] as String,
      pregnancyDuration: map['pregnancyDuration'] as int,
      uploaded: map['uploaded'] == 1,
      idBackend: map['idBackend'] != null ? map['idBackend'] as String : "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ChildModel.fromJson(String source) =>
      ChildModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChildModel(id: $id, name: $name, dateOfBirth: $dateOfBirth, imagePath: $imagePath, gender: $gender, pregnancyDuration: $pregnancyDuration, uploaded: $uploaded, idBackend: $idBackend)';
  }

  @override
  bool operator ==(covariant ChildModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.dateOfBirth == dateOfBirth &&
        other.idBackend == idBackend &&
        other.imagePath == imagePath &&
        other.gender == gender &&
        other.pregnancyDuration == pregnancyDuration &&
        other.uploaded == uploaded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        dateOfBirth.hashCode ^
        idBackend.hashCode ^
        imagePath.hashCode ^
        gender.hashCode ^
        pregnancyDuration.hashCode ^
        uploaded.hashCode;
  }
}
