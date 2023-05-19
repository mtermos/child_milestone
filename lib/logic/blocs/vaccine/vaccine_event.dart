// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'vaccine_bloc.dart';

@immutable
abstract class VaccineEvent extends Equatable {
  const VaccineEvent();
  @override
  List<Object> get props => [];
}

class AddVaccineEvent extends VaccineEvent {
  final Vaccine vaccine;

  const AddVaccineEvent({
    required this.vaccine,
  });
}

class GetAllVaccinesEvent extends VaccineEvent {}

class DeleteAllVaccinesEvent extends VaccineEvent {}

class GetVaccineEvent extends VaccineEvent {
  final int vaccineId;
  const GetVaccineEvent({required this.vaccineId});
}

class GetVaccinesWithDecisionsByAgeEvent extends VaccineEvent {
  final ChildModel child;
  const GetVaccinesWithDecisionsByAgeEvent({required this.child});
}

class GetVaccinesWithDecisionsByPeriodEvent extends VaccineEvent {
  final ChildModel child;
  final int periodId;
  const GetVaccinesWithDecisionsByPeriodEvent(
      {required this.child, required this.periodId});
}

class GetVaccinesWithDecisionsByChildEvent extends VaccineEvent {
  final ChildModel child;
  const GetVaccinesWithDecisionsByChildEvent({required this.child});
}

class GetVaccinesForSummaryEvent extends VaccineEvent {
  final ChildModel child;
  final int periodId;
  const GetVaccinesForSummaryEvent(
      {required this.child, required this.periodId});
}
