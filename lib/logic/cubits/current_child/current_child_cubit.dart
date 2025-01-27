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

  void changeCurrentChild(ChildModel newChild, Function onSuccess) async {
    emit(ChangingCurrentChildState());
    List<ChildModel> children = await childRepository.getAllChildren();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(SharedPrefKeys.selectedChildId, newChild.id);
    onSuccess();
    emit(CurrentChildChangedState(
        new_current_child: newChild, all_children: children));
  }

  void changeCurrentChildById(int id) async {
    emit(ChangingCurrentChildState());
    ChildModel? newChild = await childRepository.getChildByID(id);
    List<ChildModel> children = await childRepository.getAllChildren();
    if (newChild != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(SharedPrefKeys.selectedChildId, newChild.id);
      emit(CurrentChildChangedState(
          new_current_child: newChild, all_children: children));
    }
  }

  Future<ChildModel?> getCurrentChild() async {
    emit(ChangingCurrentChildState());
    final prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt(SharedPrefKeys.selectedChildId);
    List<ChildModel> children = await childRepository.getAllChildren();

    if (id != null && id >= 0) {
      ChildModel? child = await childRepository.getChildByID(id);

      if (child != null) {
        emit(CurrentChildChangedState(
            new_current_child: child, all_children: children));
        return child;
      } else {
        return await setFirstChildCurrent(() {});
      }
    }
    return null;
  }

  Future<ChildModel?> resetCurrentChild() async {
    emit(NoCurrentChildState());
    return null;
  }

  Future<ChildModel?> setFirstChildCurrent(Function onSuccess) async {
    List<ChildModel>? children = await childRepository.getAllChildren();
    if (children != null && children.isNotEmpty) {
      ChildModel child = children.first;
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(SharedPrefKeys.selectedChildId, child.id);
      onSuccess();
      emit(CurrentChildChangedState(
          new_current_child: child, all_children: children));
      return child;
    } else {
      onSuccess();
      emit(NoCurrentChildState());
    }
    return null;
  }
}
