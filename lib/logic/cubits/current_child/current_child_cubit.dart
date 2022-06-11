// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/repositories/child_repository.dart';

part 'current_child_state.dart';

class CurrentChildCubit extends Cubit<CurrentChildState> {
  CurrentChildCubit({
    required this.childRepository,
  }) : super(NoCurrentChildState());
  final ChildRepository childRepository;

  void change_current_child(ChildModel new_child) async {
    emit(ChangingCurrentChildState());
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(SELECTED_CHILD_ID, new_child.id);
    emit(CurrentChildChangedState(new_current_child: new_child));
  }

  void change_current_child_by_id(int id) async {
    emit(ChangingCurrentChildState());
    ChildModel? new_child = await childRepository.getChildByID(id);

    if (new_child != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(SELECTED_CHILD_ID, new_child.id);
      emit(CurrentChildChangedState(new_current_child: new_child));
    }
  }

  Future<ChildModel?> get_current_child() async {
    emit(ChangingCurrentChildState());
    final prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt(SELECTED_CHILD_ID);

    if (id != null && id >= 0) {
      ChildModel? child = await childRepository.getChildByID(id);
      if (child != null) {
        emit(CurrentChildChangedState(new_current_child: child));
        return child;
      }
    }
    return null;
  }
}
