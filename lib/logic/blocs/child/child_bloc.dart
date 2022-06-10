import 'dart:async';

import 'package:child_milestone/constants/tuples.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:child_milestone/logic/blocs/internet/internet_bloc.dart';

import '../../../data/models/child_model.dart';
import '../../../data/repositories/child_repository.dart';

part "child_event.dart";
part "child_state.dart";

class ChildBloc extends Bloc<ChildEvent, ChildState> {
  final ChildRepository childRepository;

  ChildBloc({required this.childRepository}) : super(InitialChildState()) {
    on<AddChildEvent>(add_child);
    on<GetAllChildrenEvent>(get_all_children);
    on<DeleteAllChildrenEvent>(delete_all_children);

    on<GetChildEvent>(get_child);
  }

  void add_child(AddChildEvent event, Emitter<ChildState> emit) async {
    emit(AddingChildState());
    DaoResponse result = await childRepository.insertChild(event.child);
    if (result.item1) {
      emit(AddedChildState(event.child));
      event.whenDone();
    } else if (result.item2 == 2067) {
      emit(ErrorAddingChildUniqueIDState());
    } else {
      emit(ErrorAddingChildState());
    }
  }

  void get_all_children(
      GetAllChildrenEvent event, Emitter<ChildState> emit) async {
    emit(AllChildrenLoadingState());
    // await childRepository.deleteAllChilds();
    List<ChildModel>? children = await childRepository.getAllChildren();
    if (children != null)
      emit(AllChildrenLoadedState(children));
    else
      emit(AllChildrenLoadingErrorState());
  }

  void delete_all_children(
      DeleteAllChildrenEvent event, Emitter<ChildState> emit) async {
    emit(DeleteingAllChildrenState());
    await childRepository.deleteAllChildren();
    emit(DeletedAllChildrenState());
  }

  void get_child(GetChildEvent event, Emitter<ChildState> emit) async {
    emit(ChildLoadingState());
    ChildModel? child = await childRepository.getChildByID(event.child_id);
    if (child != null)
      emit(ChildLoadedState(child));
    else
      emit(ChildLoadingErrorState());
  }
}
