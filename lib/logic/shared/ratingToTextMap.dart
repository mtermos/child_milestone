import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:child_milestone/data/models/rating.dart';

Map<String, String> ratingToTextMap(
    RatingModel ratingModel, AppLocalizations appLocalizations) {
  Map<String, String> texts = {};
  Map<int, String> questionsTexts = {
    1: appLocalizations.ratingQuestion1,
    2: appLocalizations.ratingQuestion2,
    3: appLocalizations.ratingQuestion3,
    4: appLocalizations.ratingQuestion4,
    5: appLocalizations.ratingQuestion5,
    6: appLocalizations.ratingQuestion6,
    7: appLocalizations.ratingQuestion7,
    8: appLocalizations.ratingQuestion8,
  };
  Map<int, Map<int, String>> choicesTexts = {
    1: {
      1: appLocalizations.ratingQuestion1a,
      2: appLocalizations.ratingQuestion1b,
      3: appLocalizations.ratingQuestion1c,
      4: appLocalizations.ratingQuestion1d,
      5: appLocalizations.ratingQuestion1e,
    },
    2: {
      1: appLocalizations.ratingQuestion2a,
      2: appLocalizations.ratingQuestion2b,
      3: appLocalizations.ratingQuestion2c,
      4: appLocalizations.ratingQuestion2d,
    },
    3: {
      1: appLocalizations.ratingQuestion3a,
      2: appLocalizations.ratingQuestion3b,
      3: appLocalizations.ratingQuestion3c,
      4: appLocalizations.ratingQuestion3d,
      5: appLocalizations.ratingQuestion3e,
    },
    4: {
      1: appLocalizations.ratingQuestion4a,
      2: appLocalizations.ratingQuestion4b,
      3: appLocalizations.ratingQuestion4c,
      4: appLocalizations.ratingQuestion4d,
    },
    5: {
      1: appLocalizations.ratingQuestion5a,
      2: appLocalizations.ratingQuestion5b,
      3: appLocalizations.ratingQuestion5c,
      4: appLocalizations.ratingQuestion5d,
      5: appLocalizations.ratingQuestion5e,
    },
    6: {
      1: appLocalizations.ratingQuestion6a,
      2: appLocalizations.ratingQuestion6b,
      3: appLocalizations.ratingQuestion6c,
      4: appLocalizations.ratingQuestion6d,
      5: appLocalizations.ratingQuestion6e,
    },
    7: {
      1: appLocalizations.ratingQuestion7a,
      2: appLocalizations.ratingQuestion7b,
      3: appLocalizations.ratingQuestion7c,
      4: appLocalizations.ratingQuestion7d,
      5: appLocalizations.ratingQuestion7e,
    },
    8: {
      1: appLocalizations.ratingQuestion8a,
      2: appLocalizations.ratingQuestion8b,
      3: appLocalizations.ratingQuestion8c,
      4: appLocalizations.ratingQuestion8d,
      5: appLocalizations.ratingQuestion8e,
      6: appLocalizations.ratingQuestion8f,
      7: appLocalizations.ratingQuestion8g,
      8: appLocalizations.ratingQuestion8h,
    },
  };

  texts["question"] = questionsTexts[ratingModel.ratingId] ?? "";
  if (ratingModel.ratingId == 8) {
    if (ratingModel.multipleRatings != "") {
      List<String> list = ratingModel.multipleRatings.split('-');
      String choiceText = "";
      bool first = true;
      for (var element in list) {
        int choice = 0;
        try {
          choice = int.parse(element);
          if (first) {
            choiceText = choicesTexts[8]![choice] ?? "";
            first = false;
          } else {
            choiceText += " و ${choicesTexts[8]![choice] ?? ""}";
          }
        } catch (e) {}
      }
      texts["choice"] = choiceText;
    }
  } else {
    texts["choice"] =
        choicesTexts[ratingModel.ratingId]![ratingModel.rating] ?? "";
  }
  texts["additionalText"] = ratingModel.additionalText;

  return texts;
}
