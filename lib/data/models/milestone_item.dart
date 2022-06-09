// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MilestoneItem {
  int id;
  String description;
  int startingWeek;
  int endingWeek;
  int category;
  String? imagePath;
  String? videoPath;
  MilestoneItem({
    required this.id,
    required this.description,
    required this.startingWeek,
    required this.endingWeek,
    required this.category,
    this.imagePath,
    this.videoPath,
  });

  MilestoneItem copyWith({
    int? id,
    String? description,
    int? startingWeek,
    int? endingWeek,
    int? category,
    String? imagePath,
    String? videoPath,
  }) {
    return MilestoneItem(
      id: id ?? this.id,
      description: description ?? this.description,
      startingWeek: startingWeek ?? this.startingWeek,
      endingWeek: endingWeek ?? this.endingWeek,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      videoPath: videoPath ?? this.videoPath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'startingWeek': startingWeek,
      'endingWeek': endingWeek,
      'category': category,
      'imagePath': imagePath,
      'videoPath': videoPath,
    };
  }

  factory MilestoneItem.fromMap(Map<String, dynamic> map) {
    return MilestoneItem(
      id: map['id'] as int,
      description: map['description'] as String,
      startingWeek: map['startingWeek'] as int,
      endingWeek: map['endingWeek'] as int,
      category: map['category'] as int,
      imagePath: map['imagePath'] != null ? map['imagePath'] as String : null,
      videoPath: map['videoPath'] != null ? map['videoPath'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MilestoneItem.fromJson(String source) =>
      MilestoneItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MilestoneItem(id: $id, description: $description, startingWeek: $startingWeek, endingWeek: $endingWeek, category: $category, imagePath: $imagePath, videoPath: $videoPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MilestoneItem &&
        other.id == id &&
        other.description == description &&
        other.startingWeek == startingWeek &&
        other.endingWeek == endingWeek &&
        other.category == category &&
        other.imagePath == imagePath &&
        other.videoPath == videoPath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        startingWeek.hashCode ^
        endingWeek.hashCode ^
        category.hashCode ^
        imagePath.hashCode ^
        videoPath.hashCode;
  }
}
