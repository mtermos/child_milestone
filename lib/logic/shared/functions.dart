import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/constants/monthly_periods.dart';
import 'package:child_milestone/constants/yearly_periods.dart';
import 'package:child_milestone/data/models/child_model.dart';

Period periodCalculator(DateTime dateOfBirth) {
  DateTime tempStart, tempEnd;
  DateTime nowDate = DateTime.now();
  for (var period in monthlyPeriods) {
    tempStart = DateTime(dateOfBirth.year,
        dateOfBirth.month + period.startingMonth, dateOfBirth.day);
    tempEnd = DateTime(dateOfBirth.year, dateOfBirth.month + period.endingMonth,
        dateOfBirth.day);
    if (tempStart.isBefore(nowDate) && tempEnd.isAfter(nowDate)) {
      return period;
    }
  }
  for (var period in yearlyPeriods) {
    tempStart = DateTime(dateOfBirth.year + period.startingYear,
        dateOfBirth.month, dateOfBirth.day);
    tempEnd = DateTime(dateOfBirth.year + period.endingYear, dateOfBirth.month,
        dateOfBirth.day);
    if (tempStart.isBefore(nowDate) && tempEnd.isAfter(nowDate)) {
      return period;
    }
  }
  return Period(id: 0, arabicName: "null");
}

String noImageAsset(ChildModel childModel) {
  String noImageAsset = "";
  String babyBoy = "assets/images/children/baby_boy.png";
  String babyGirl = "assets/images/children/baby_girl.png";
  String youngBoy = "assets/images/children/young_boy.png";
  String youngGirl = "assets/images/children/young_girl.png";
  int age = DateTime.now().difference(childModel.dateOfBirth).inDays ~/ 30;
  if (childModel.gender == "Male") {
    if (age > 24) {
      noImageAsset = youngBoy;
    } else {
      noImageAsset = babyBoy;
    }
  } else {
    if (age > 24) {
      noImageAsset = youngGirl;
    } else {
      noImageAsset = babyGirl;
    }
  }
  return noImageAsset;
}
