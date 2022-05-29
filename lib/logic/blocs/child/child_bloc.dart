import 'dart:async';

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
  }

  void add_child(AddChildEvent event, Emitter<ChildState> emit) async {
    emit(AddingChildState());
    await childRepository.insertChild(event.child);
    emit(AddedChildState());
  }

  void get_all_children(
      GetAllChildrenEvent event, Emitter<ChildState> emit) async {
    emit(AllChildrenLoadingState());
    // await childRepository.deleteAllChilds();
    List<ChildModel> children = await childRepository.getAllChildren();
    emit(AllChildrenLoadedState(children));
  }

  void delete_all_children(
      DeleteAllChildrenEvent event, Emitter<ChildState> emit) async {
    emit(DeleteingAllChildrenState());
    await childRepository.deleteAllChilds();
    emit(DeletedAllChildrenState());
  }
}
