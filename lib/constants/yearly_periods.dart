// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields
import 'classes.dart';

class YearlyPeriod extends Period {
  @override
  int id;
  int startingYear;
  int endingYear;
  int numWeeks;
  @override
  String arabicName;
  @override
  String arabicNameNumbers;
  YearlyPeriod({
    required this.id,
    required this.startingYear,
    required this.endingYear,
    required this.numWeeks,
    required this.arabicName,
    required this.arabicNameNumbers,
  }) : super(
            id: id,
            arabicName: arabicName,
            arabicNameNumbers: arabicNameNumbers);
}

List<YearlyPeriod> yearlyPeriods = [
  YearlyPeriod(
    id: 11,
    startingYear: 3,
    endingYear: 4,
    numWeeks: 48,
    arabicName: 'من السنة الثالثة حتى الرابعة',
    arabicNameNumbers: 'السنة 3 حتى 4',
  ),
  YearlyPeriod(
    id: 12,
    startingYear: 4,
    endingYear: 5,
    numWeeks: 48,
    arabicName: 'من السنة الرابعة حتى الخامسة',
    arabicNameNumbers: 'السنة 4 حتى 5',
  ),
];
