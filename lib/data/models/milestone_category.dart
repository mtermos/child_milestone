// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MilestoneCategoryModel {
  int id;
  String name;
  String icon_path;
  MilestoneCategoryModel({
    required this.id,
    required this.name,
    required this.icon_path,
  });

  MilestoneCategoryModel copyWith({
    int? id,
    String? name,
    String? icon_path,
  }) {
    return MilestoneCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon_path: icon_path ?? this.icon_path,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'icon_path': icon_path,
    };
  }

  factory MilestoneCategoryModel.fromMap(Map<String, dynamic> map) {
    return MilestoneCategoryModel(
      id: map['id'] as int,
      name: map['name'] as String,
      icon_path: map['icon_path'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MilestoneCategoryModel.fromJson(String source) =>
      MilestoneCategoryModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MilestoneCategoryModel(id: $id, name: $name, icon_path: $icon_path)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MilestoneCategoryModel &&
        other.id == id &&
        other.name == name &&
        other.icon_path == icon_path;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ icon_path.hashCode;
}
