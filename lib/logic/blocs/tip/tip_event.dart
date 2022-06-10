// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'tip_bloc.dart';

@immutable
abstract class TipEvent extends Equatable {
  const TipEvent();
  @override
  List<Object> get props => [];
}

class AddTipEvent extends TipEvent {
  TipModel tip;

  AddTipEvent({
    required this.tip,
  });
}

class GetAllTipsEvent extends TipEvent {}

class DeleteAllTipsEvent extends TipEvent {}

class GetTipEvent extends TipEvent {
  int tip_id;
  GetTipEvent({required this.tip_id});
}

class GetTipsByAgeEvent extends TipEvent {
  DateTime dateOfBirth;
  GetTipsByAgeEvent({required this.dateOfBirth});
}
