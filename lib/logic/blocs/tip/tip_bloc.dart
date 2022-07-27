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
    on<AddTipEvent>(addTip);
    on<GetAllTipsEvent>(getAllTips);
    on<DeleteAllTipsEvent>(deleteAllTips);

    on<GetTipEvent>(getTip);
    on<GetTipsByAgeEvent>(getByAge);
  }

  void addTip(AddTipEvent event, Emitter<TipState> emit) async {
    emit(AddingTipState());
    await tipRepository.insertTip(event.tip);
    emit(AddedTipState());
  }

  void getAllTips(GetAllTipsEvent event, Emitter<TipState> emit) async {
    emit(AllTipsLoadingState());
    // await tipRepository.deleteAllTips();
    List<TipModel>? tips = await tipRepository.getAllTips();
    if (tips != null) {
      emit(AllTipsLoadedState(tips));
    } else {
      emit(AllTipsLoadingErrorState());
    }
  }

  void deleteAllTips(DeleteAllTipsEvent event, Emitter<TipState> emit) async {
    emit(DeleteingAllTipsState());
    await tipRepository.deleteAllTips();
    emit(DeletedAllTipsState());
  }

  void getTip(GetTipEvent event, Emitter<TipState> emit) async {
    emit(TipLoadingState());
    TipModel? tip = await tipRepository.getTipByID(event.tipId);
    if (tip != null) {
      emit(TipLoadedState(tip));
    } else {
      emit(TipLoadingErrorState());
    }
  }

  void getByAge(GetTipsByAgeEvent event, Emitter<TipState> emit) async {
    emit(LoadingTipsByAgeState());
    List<TipModel>? tips = await tipRepository.getTipsByAge(event.dateOfBirth);
    if (tips != null) {
      emit(LoadedTipsByAgeState(tips));
    } else {
      emit(ErrorLoadingTipsByAgeState());
    }
  }
}
