// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TipModel {
  int id;
  String title;
  String body;
  String? videoURL;
  String? documentURL;
  String? webURL;
  int period;
  TipModel({
    required this.id,
    required this.title,
    required this.body,
    this.videoURL,
    this.documentURL,
    this.webURL,
    required this.period,
  });

  TipModel copyWith({
    int? id,
    String? title,
    String? body,
    String? videoURL,
    String? documentURL,
    String? webURL,
    int? period,
  }) {
    return TipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      videoURL: videoURL ?? this.videoURL,
      documentURL: documentURL ?? this.documentURL,
      webURL: webURL ?? this.webURL,
      period: period ?? this.period,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'videoURL': videoURL,
      'documentURL': documentURL,
      'webURL': webURL,
      'period': period,
    };
  }

  factory TipModel.fromMap(Map<String, dynamic> map) {
    return TipModel(
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      videoURL: map['videoURL'] != null ? map['videoURL'] as String : null,
      documentURL:
          map['documentURL'] != null ? map['documentURL'] as String : null,
      webURL: map['webURL'] != null ? map['webURL'] as String : null,
      period: map['period'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TipModel.fromJson(String source) =>
      TipModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TipModel(id: $id, title: $title, body: $body, videoURL: $videoURL, documentURL: $documentURL, webURL: $webURL, period: $period)';
  }

  @override
  bool operator ==(covariant TipModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.body == body &&
        other.videoURL == videoURL &&
        other.documentURL == documentURL &&
        other.webURL == webURL &&
        other.period == period;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        videoURL.hashCode ^
        documentURL.hashCode ^
        webURL.hashCode ^
        period.hashCode;
  }
}
