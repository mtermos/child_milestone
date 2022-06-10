part of 'tip_bloc.dart';

@immutable
abstract class TipState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialTipState extends TipState {}

class AddingTipState extends TipState {}

class AddedTipState extends TipState {}

class TipLoadingState extends TipState {}

class TipLoadingErrorState extends TipState {}

class TipLoadedState extends TipState {
  final TipModel tip;

  TipLoadedState(this.tip);

  @override
  List<Object?> get props => [tip];
}

class AllTipsLoadingState extends TipState {}

class AllTipsLoadingErrorState extends TipState {}

class AllTipsLoadedState extends TipState {
  final List<TipModel> tips;

  AllTipsLoadedState(this.tips);

  @override
  List<Object?> get props => [tips];
}

class DeleteingAllTipsState extends TipState {}

class DeletedAllTipsState extends TipState {}

class TipErrorState extends TipState {
  final String error;

  TipErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class LoadingTipsByAgeState extends TipState {}

class ErrorLoadingTipsByAgeState extends TipState {}

class LoadedTipsByAgeState extends TipState {
  final List<TipModel> tips;

  LoadedTipsByAgeState(this.tips);

  @override
  List<Object?> get props => [tips];
}
