import 'package:child_milestone/data/models/rating_questions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<RatingQuestion> ratingsQuestions(context) {
  return [
    RatingQuestion(
      id: 1,
      text: AppLocalizations.of(context)!.ratingQuestion1,
      choices: {
        1: AppLocalizations.of(context)!.ratingQuestion1a,
        2: AppLocalizations.of(context)!.ratingQuestion1b,
        3: AppLocalizations.of(context)!.ratingQuestion1c,
        4: AppLocalizations.of(context)!.ratingQuestion1d,
        5: AppLocalizations.of(context)!.ratingQuestion1e,
      },
      regularNext: 3,
      specialNext: 2,
      specialNextCondition: 5,
      hasTextField: false,
      displayTextFieldCondition: -1,
      multipleChoice: false,
    ),
    RatingQuestion(
      id: 2,
      text: AppLocalizations.of(context)!.ratingQuestion2,
      choices: {
        1: AppLocalizations.of(context)!.ratingQuestion2a,
        2: AppLocalizations.of(context)!.ratingQuestion2b,
        3: AppLocalizations.of(context)!.ratingQuestion2c,
        4: AppLocalizations.of(context)!.ratingQuestion2d,
      },
      regularNext: 3,
      specialNext: 0,
      specialNextCondition: -1,
      hasTextField: true,
      displayTextFieldCondition: 4,
      multipleChoice: false,
    ),
    RatingQuestion(
      id: 3,
      text: AppLocalizations.of(context)!.ratingQuestion3,
      choices: {
        1: AppLocalizations.of(context)!.ratingQuestion3a,
        2: AppLocalizations.of(context)!.ratingQuestion3b,
        3: AppLocalizations.of(context)!.ratingQuestion3c,
        4: AppLocalizations.of(context)!.ratingQuestion3d,
        5: AppLocalizations.of(context)!.ratingQuestion3e,
      },
      regularNext: 5,
      specialNext: 4,
      specialNextCondition: 5,
      hasTextField: false,
      displayTextFieldCondition: -1,
      multipleChoice: false,
    ),
    RatingQuestion(
      id: 4,
      text: AppLocalizations.of(context)!.ratingQuestion4,
      choices: {
        1: AppLocalizations.of(context)!.ratingQuestion4a,
        2: AppLocalizations.of(context)!.ratingQuestion4b,
        3: AppLocalizations.of(context)!.ratingQuestion4c,
        4: AppLocalizations.of(context)!.ratingQuestion4d,
      },
      regularNext: 5,
      specialNext: 0,
      specialNextCondition: -1,
      hasTextField: true,
      displayTextFieldCondition: 4,
      multipleChoice: false,
    ),
    RatingQuestion(
      id: 5,
      text: AppLocalizations.of(context)!.ratingQuestion5,
      choices: {
        1: AppLocalizations.of(context)!.ratingQuestion5a,
        2: AppLocalizations.of(context)!.ratingQuestion5b,
        3: AppLocalizations.of(context)!.ratingQuestion5c,
        4: AppLocalizations.of(context)!.ratingQuestion5d,
        5: AppLocalizations.of(context)!.ratingQuestion5e,
      },
      regularNext: 6,
      specialNext: 0,
      specialNextCondition: -1,
      hasTextField: true,
      displayTextFieldCondition: 5,
      multipleChoice: false,
    ),
    RatingQuestion(
      id: 6,
      text: AppLocalizations.of(context)!.ratingQuestion6,
      choices: {
        1: AppLocalizations.of(context)!.ratingQuestion6a,
        2: AppLocalizations.of(context)!.ratingQuestion6b,
        3: AppLocalizations.of(context)!.ratingQuestion6c,
        4: AppLocalizations.of(context)!.ratingQuestion6d,
        5: AppLocalizations.of(context)!.ratingQuestion6e,
      },
      regularNext: 7,
      specialNext: 0,
      specialNextCondition: -1,
      hasTextField: false,
      displayTextFieldCondition: -1,
      multipleChoice: false,
    ),
    RatingQuestion(
      id: 7,
      text: AppLocalizations.of(context)!.ratingQuestion7,
      choices: {
        1: AppLocalizations.of(context)!.ratingQuestion7a,
        2: AppLocalizations.of(context)!.ratingQuestion7b,
        3: AppLocalizations.of(context)!.ratingQuestion7c,
        4: AppLocalizations.of(context)!.ratingQuestion7d,
        5: AppLocalizations.of(context)!.ratingQuestion7e,
      },
      regularNext: 8,
      specialNext: 0,
      specialNextCondition: -1,
      hasTextField: false,
      displayTextFieldCondition: -1,
      multipleChoice: false,
    ),
    RatingQuestion(
      id: 8,
      text: AppLocalizations.of(context)!.ratingQuestion8,
      choices: {
        1: AppLocalizations.of(context)!.ratingQuestion8a,
        2: AppLocalizations.of(context)!.ratingQuestion8b,
        3: AppLocalizations.of(context)!.ratingQuestion8c,
        4: AppLocalizations.of(context)!.ratingQuestion8d,
        5: AppLocalizations.of(context)!.ratingQuestion8e,
        6: AppLocalizations.of(context)!.ratingQuestion8f,
        7: AppLocalizations.of(context)!.ratingQuestion8g,
        8: AppLocalizations.of(context)!.ratingQuestion8h,
      },
      regularNext: 0,
      specialNext: 0,
      specialNextCondition: -1,
      hasTextField: false,
      displayTextFieldCondition: -1,
      multipleChoice: true,
    ),
  ];
}