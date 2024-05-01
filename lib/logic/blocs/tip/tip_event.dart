// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'tip_bloc.dart';

@immutable
abstract class TipEvent extends Equatable {
  const TipEvent();
  @override
  List<Object> get props => [];
}

class AddTipEvent extends TipEvent {
  final TipModel tip;

  const AddTipEvent({
    required this.tip,
  });
}

class GetAllTipsEvent extends TipEvent {}

class DeleteAllTipsEvent extends TipEvent {}

class GetTipEvent extends TipEvent {
  final int tipId;
  const GetTipEvent({required this.tipId});
}

class GetTipsByAgeEvent extends TipEvent {
  ChildModel child;
  GetTipsByAgeEvent({required this.child});
}
