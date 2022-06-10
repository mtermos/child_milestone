import 'package:child_milestone/data/models/tip.dart';
import 'package:child_milestone/data/repositories/tip_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'tip_event.dart';
part 'tip_state.dart';

class TipBloc extends Bloc<TipEvent, TipState> {
  final TipRepository tipRepository;

  TipBloc({required this.tipRepository}) : super(InitialTipState()) {
    on<AddTipEvent>(add_tip);
    on<GetAllTipsEvent>(get_all_tips);
    on<DeleteAllTipsEvent>(delete_all_tips);

    on<GetTipEvent>(get_tip);
    on<GetTipsByAgeEvent>(get_by_age);
  }

  void add_tip(AddTipEvent event, Emitter<TipState> emit) async {
    emit(AddingTipState());
    await tipRepository.insertTip(event.tip);
    emit(AddedTipState());
  }

  void get_all_tips(GetAllTipsEvent event, Emitter<TipState> emit) async {
    emit(AllTipsLoadingState());
    // await tipRepository.deleteAllTips();
    List<TipModel>? tips = await tipRepository.getAllTips();
    if (tips != null) {
      emit(AllTipsLoadedState(tips));
    } else {
      emit(AllTipsLoadingErrorState());
    }
  }

  void delete_all_tips(DeleteAllTipsEvent event, Emitter<TipState> emit) async {
    emit(DeleteingAllTipsState());
    await tipRepository.deleteAllTips();
    emit(DeletedAllTipsState());
  }

  void get_tip(GetTipEvent event, Emitter<TipState> emit) async {
    emit(TipLoadingState());
    TipModel? tip = await tipRepository.getTipByID(event.tip_id);
    if (tip != null) {
      emit(TipLoadedState(tip));
    } else {
      emit(TipLoadingErrorState());
    }
  }

  void get_by_age(GetTipsByAgeEvent event, Emitter<TipState> emit) async {
    emit(LoadingTipsByAgeState());
    List<TipModel>? tips = await tipRepository.getTipsByAge(event.dateOfBirth);
    if (tips != null) {
      emit(LoadedTipsByAgeState(tips));
    } else {
      emit(ErrorLoadingTipsByAgeState());
    }
  }
}
