// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RatingModel {
  int? id;
  int ratingId;
  double rating;
  bool uploaded;
  DateTime takenAt;
  RatingModel({
    this.id,
    required this.ratingId,
    required this.rating,
    required this.uploaded,
    required this.takenAt,
  });

  RatingModel copyWith({
    int? id,
    int? ratingId,
    double? rating,
    bool? uploaded,
    DateTime? takenAt,
  }) {
    return RatingModel(
      id: id ?? this.id,
      ratingId: ratingId ?? this.ratingId,
      rating: rating ?? this.rating,
      uploaded: uploaded ?? this.uploaded,
      takenAt: takenAt ?? this.takenAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ratingId': ratingId,
      'rating': rating,
      'uploaded': uploaded ? 1 : 0,
      'takenAt': takenAt.millisecondsSinceEpoch,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      id: map['id'] != null ? map['id'] as int : null,
      ratingId: map['ratingId'] as int,
      rating: map['rating'] as double,
      uploaded: map['uploaded'] == 1,
      takenAt: DateTime.fromMillisecondsSinceEpoch(map['takenAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory RatingModel.fromJson(String source) =>
      RatingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RatingModel(id: $id, ratingId: $ratingId, rating: $rating, uploaded: $uploaded, takenAt: $takenAt)';
  }

  @override
  bool operator ==(covariant RatingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ratingId == ratingId &&
        other.rating == rating &&
        other.uploaded == uploaded &&
        other.takenAt == takenAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ratingId.hashCode ^
        rating.hashCode ^
        uploaded.hashCode ^
        takenAt.hashCode;
  }
}
