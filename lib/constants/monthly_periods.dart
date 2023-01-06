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
  @override
  String arabicNameNumbers;
  MonthlyPeriod({
    required this.id,
    required this.startingMonth,
    required this.endingMonth,
    required this.numWeeks,
    required this.arabicName,
    required this.arabicNameNumbers,
  }) : super(
            id: id,
            arabicName: arabicName,
            arabicNameNumbers: arabicNameNumbers);
}

List<MonthlyPeriod> monthlyPeriods = [
  MonthlyPeriod(
    id: 1,
    startingMonth: 0,
    endingMonth: 2,
    numWeeks: 8,
    arabicName: 'منذ الولادة حتى الشهر الثاني',
    arabicNameNumbers: 'الولادة حتى الشهر 2',
  ),
  MonthlyPeriod(
    id: 2,
    startingMonth: 2,
    endingMonth: 4,
    numWeeks: 8,
    arabicName: 'من الشهر الثاني حتى الرابع',
    arabicNameNumbers: 'الأشهر 2 حتى 4',
  ),
  MonthlyPeriod(
    id: 3,
    startingMonth: 4,
    endingMonth: 6,
    numWeeks: 8,
    arabicName: 'من الشهر الرابع حتى السادس',
    arabicNameNumbers: 'الأشهر 4 حتى 6',
  ),
  MonthlyPeriod(
    id: 4,
    startingMonth: 6,
    endingMonth: 9,
    numWeeks: 12,
    arabicName: 'من الشهر السادس حتى التاسع',
    arabicNameNumbers: 'الأشهر 6 حتى 9',
  ),
  MonthlyPeriod(
    id: 5,
    startingMonth: 9,
    endingMonth: 12,
    numWeeks: 12,
    arabicName: 'من الشهر التاسع حتى الثاني عشر',
    arabicNameNumbers: 'الأشهر 9 حتى 12',
  ),
  MonthlyPeriod(
    id: 6,
    startingMonth: 12,
    endingMonth: 15,
    numWeeks: 12,
    arabicName: 'من الشهر الثاني عشر حتى الخامس عشر',
    arabicNameNumbers: 'الأشهر 12 حتى 15',
  ),
  MonthlyPeriod(
    id: 7,
    startingMonth: 15,
    endingMonth: 18,
    numWeeks: 12,
    arabicName: 'من الشهر الخامس عشر حتى الثامن عشر',
    arabicNameNumbers: 'الأشهر 15 حتى 18',
  ),
  MonthlyPeriod(
    id: 8,
    startingMonth: 18,
    endingMonth: 24,
    numWeeks: 24,
    arabicName: 'من الشهر الثامن عشر حتى الرابع والعشرين',
    arabicNameNumbers: 'الأشهر 18 حتى 24',
  ),
  MonthlyPeriod(
    id: 9,
    startingMonth: 24,
    endingMonth: 30,
    numWeeks: 24,
    arabicName: 'من الشهر الرابع والعشرين حتى الثلاثين',
    arabicNameNumbers: 'الأشهر 24 حتى 30',
  ),
  MonthlyPeriod(
    id: 10,
    startingMonth: 30,
    endingMonth: 36,
    numWeeks: 24,
    arabicName: 'من الشهر الثلاثين حتى السادسة والثلاثين',
    arabicNameNumbers: 'الأشهر 30 حتى 36',
  )
];
