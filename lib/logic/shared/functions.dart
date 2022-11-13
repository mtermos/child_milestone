import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/constants/monthly_periods.dart';
import 'package:child_milestone/constants/yearly_periods.dart';

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
