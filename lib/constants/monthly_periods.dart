// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields
import 'package:child_milestone/constants/classes.dart';

class MonthlyPeriod extends Period {
  @override
  int id;
  int startingMonth;
  int endingMonth;
  int numWeeks;
  @override
  String arabicName;
  MonthlyPeriod({
    required this.id,
    required this.startingMonth,
    required this.endingMonth,
    required this.numWeeks,
    required this.arabicName,
  }) : super(id: id, arabicName: arabicName);
}

List<MonthlyPeriod> monthlyPeriods = [
  MonthlyPeriod(
      id: 1,
      startingMonth: 0,
      endingMonth: 2,
      numWeeks: 8,
      arabicName: 'منذ الولادة حتى الشهر الثاني'),
  MonthlyPeriod(
      id: 2,
      startingMonth: 2,
      endingMonth: 4,
      numWeeks: 8,
      arabicName: 'من الشهر الثاني حتى الرابع'),
  MonthlyPeriod(
      id: 3,
      startingMonth: 4,
      endingMonth: 6,
      numWeeks: 8,
      arabicName: 'من الشهر الرابع حتى السادس'),
  MonthlyPeriod(
      id: 4,
      startingMonth: 6,
      endingMonth: 9,
      numWeeks: 12,
      arabicName: 'من الشهر السادس حتى التاسع'),
  MonthlyPeriod(
      id: 5,
      startingMonth: 9,
      endingMonth: 12,
      numWeeks: 12,
      arabicName: 'من الشهر التاسع حتى الثاني عشر'),
  MonthlyPeriod(
      id: 6,
      startingMonth: 12,
      endingMonth: 15,
      numWeeks: 12,
      arabicName: 'من الشهر الثاني عشر حتى الخامس عشر'),
  MonthlyPeriod(
      id: 7,
      startingMonth: 15,
      endingMonth: 18,
      numWeeks: 12,
      arabicName: 'من الشهر الخامس عشر حتى الثامن عشر'),
  MonthlyPeriod(
      id: 8,
      startingMonth: 18,
      endingMonth: 24,
      numWeeks: 24,
      arabicName: 'من الشهر الثامن عشر حتى الرابع والعشرين'),
  MonthlyPeriod(
      id: 9,
      startingMonth: 24,
      endingMonth: 30,
      numWeeks: 24,
      arabicName: 'من الشهر الرابع والعشرين حتى الثلاثين'),
  MonthlyPeriod(
      id: 10,
      startingMonth: 30,
      endingMonth: 36,
      numWeeks: 24,
      arabicName: 'من الشهر الثلاثين حتى السادسة والثلاثين')
];
