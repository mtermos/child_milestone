// ignore_for_file: public_member_api_docs, sort_constructors_first
class YearlyPeriod {
  int id;
  int startingYear;
  int endingYear;
  YearlyPeriod({
    required this.id,
    required this.startingYear,
    required this.endingYear,
  });
}

List<YearlyPeriod> yearlyPeriods = [
  YearlyPeriod(id: 11, startingYear: 3, endingYear: 4),
  YearlyPeriod(id: 12, startingYear: 4, endingYear: 5),
];
