// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

ChildModel childModelFromJson(String str) =>
    ChildModel.fromJson(json.decode(str));

String childModelToJson(ChildModel data) => json.encode(data.toJson());

class ChildModel {
  String name;
  DateTime date_of_birth;

  ChildModel({
    required this.name,
    required this.date_of_birth,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) => ChildModel(
        name: json["name"] ?? "",
        date_of_birth: json["price_per_meter"] ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date_of_birth": date_of_birth,
      };

  @override
  String toString() => 'ChildModel(name: $name, date_of_birth: $date_of_birth)';

  ChildModel copyWith({
    String? name,
    DateTime? date_of_birth,
  }) {
    return ChildModel(
      name: name ?? this.name,
      date_of_birth: date_of_birth ?? this.date_of_birth,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'date_of_birth': date_of_birth,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map) {
    return ChildModel(
      name: map['name'] as String,
      date_of_birth: map['date_of_birth'] as DateTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChildModel &&
        other.name == name &&
        other.date_of_birth == date_of_birth;
  }

  @override
  int get hashCode => name.hashCode ^ date_of_birth.hashCode;
}
