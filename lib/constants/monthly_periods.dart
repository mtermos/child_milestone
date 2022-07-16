// ignore_for_file: public_member_api_docs, sort_constructors_first
class MonthlyPeriod {
  int id;
  int startingMonth;
  int endingMonth;
  int numWeeks;
  MonthlyPeriod({
    required this.id,
    required this.startingMonth,
    required this.endingMonth,
    required this.numWeeks,
  });
}

List<MonthlyPeriod> monthlyPeriods = [
  MonthlyPeriod(id: 1, startingMonth: 0, endingMonth: 2, numWeeks: 8),
  MonthlyPeriod(id: 2, startingMonth: 2, endingMonth: 4, numWeeks: 8),
  MonthlyPeriod(id: 3, startingMonth: 4, endingMonth: 6, numWeeks: 8),
  MonthlyPeriod(id: 4, startingMonth: 6, endingMonth: 9, numWeeks: 12),
  MonthlyPeriod(id: 5, startingMonth: 9, endingMonth: 12, numWeeks: 12),
  MonthlyPeriod(id: 6, startingMonth: 12, endingMonth: 15, numWeeks: 12),
  MonthlyPeriod(id: 7, startingMonth: 15, endingMonth: 18, numWeeks: 12),
  MonthlyPeriod(id: 8, startingMonth: 18, endingMonth: 24, numWeeks: 24),
  MonthlyPeriod(id: 9, startingMonth: 24, endingMonth: 30, numWeeks: 24),
  MonthlyPeriod(id: 10, startingMonth: 30, endingMonth: 36, numWeeks: 24)
];
