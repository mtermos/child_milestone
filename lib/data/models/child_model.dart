// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

ChildModel childModelFromJson(String str) =>
    ChildModel.fromJson(json.decode(str));

String childModelToJson(ChildModel data) => json.encode(data.toJson());

class ChildModel {
  String name;
  DateTime date_of_birth;
  String image;

  ChildModel({
    required this.name,
    required this.date_of_birth,
    required this.image,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) => ChildModel(
        name: json["name"] ?? "",
        date_of_birth: json["date_of_birth"] ?? DateTime.now(),
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date_of_birth": date_of_birth,
      };

  @override
  String toString() =>
      'ChildModel(name: $name, date_of_birth: $date_of_birth, image: $image)';

  ChildModel copyWith({
    String? name,
    String? image,
    DateTime? date_of_birth,
  }) {
    return ChildModel(
      name: name ?? this.name,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'date_of_birth': date_of_birth,
      'image': image,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map) {
    return ChildModel(
      name: map['name'] as String,
      image: map['image'] as String,
      date_of_birth: map['date_of_birth'] as DateTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChildModel &&
        other.name == name &&
        other.date_of_birth == date_of_birth &&
        other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ date_of_birth.hashCode ^ image.hashCode;
}
