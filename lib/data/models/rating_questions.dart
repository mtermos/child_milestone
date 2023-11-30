// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class RatingQuestion {
  int? id;
  String text;
  Map<int, String> choices;
  int regularNext;
  int specialNext;
  int specialNextCondition;
  bool hasTextField;
  int displayTextFieldCondition;
  bool multipleChoice;
  RatingQuestion({
    this.id,
    required this.text,
    required this.choices,
    required this.regularNext,
    required this.specialNext,
    required this.specialNextCondition,
    required this.hasTextField,
    required this.displayTextFieldCondition,
    required this.multipleChoice,
  });

  RatingQuestion copyWith({
    int? id,
    String? text,
    Map<int, String>? choices,
    int? regularNext,
    int? specialNext,
    int? specialNextCondition,
    bool? hasTextField,
    int? displayTextFieldCondition,
    bool? multipleChoice,
  }) {
    return RatingQuestion(
      id: id ?? this.id,
      text: text ?? this.text,
      choices: choices ?? this.choices,
      regularNext: regularNext ?? this.regularNext,
      specialNext: specialNext ?? this.specialNext,
      specialNextCondition: specialNextCondition ?? this.specialNextCondition,
      hasTextField: hasTextField ?? this.hasTextField,
      displayTextFieldCondition:
          displayTextFieldCondition ?? this.displayTextFieldCondition,
      multipleChoice: multipleChoice ?? this.multipleChoice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'choices': choices,
      'regularNext': regularNext,
      'specialNext': specialNext,
      'specialNextCondition': specialNextCondition,
      'hasTextField': hasTextField,
      'displayTextFieldCondition': displayTextFieldCondition,
      'multipleChoice': multipleChoice,
    };
  }

  factory RatingQuestion.fromMap(Map<String, dynamic> map) {
    return RatingQuestion(
      id: map['id'] != null ? map['id'] as int : null,
      text: map['text'] as String,
      choices: Map<int, String>.from(map['choices'] as Map<int, String>),
      regularNext: map['regularNext'] as int,
      specialNext: map['specialNext'] as int,
      specialNextCondition: map['specialNextCondition'] as int,
      hasTextField: map['hasTextField'] == 1,
      displayTextFieldCondition: map['displayTextFieldCondition'] as int,
      multipleChoice: map['multipleChoice'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory RatingQuestion.fromJson(String source) =>
      RatingQuestion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RatingQuestion(id: $id, text: $text, choices: $choices, regularNext: $regularNext, specialNext: $specialNext, specialNextCondition: $specialNextCondition, hasTextField: $hasTextField, displayTextFieldCondition: $displayTextFieldCondition, multipleChoice: $multipleChoice)';
  }

  @override
  bool operator ==(covariant RatingQuestion other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        mapEquals(other.choices, choices) &&
        other.regularNext == regularNext &&
        other.specialNext == specialNext &&
        other.specialNextCondition == specialNextCondition &&
        other.hasTextField == hasTextField &&
        other.displayTextFieldCondition == displayTextFieldCondition &&
        other.multipleChoice == multipleChoice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        choices.hashCode ^
        regularNext.hashCode ^
        specialNext.hashCode ^
        specialNextCondition.hashCode ^
        hasTextField.hashCode ^
        displayTextFieldCondition.hashCode ^
        multipleChoice.hashCode;
  }
}
