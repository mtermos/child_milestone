import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';
import 'package:child_milestone/data/models/child_model.dart';

part 'current_child_state.dart';

class CurrentChildCubit extends Cubit<CurrentChildState> {
  CurrentChildCubit() : super(NoCurrentChildState());

  void change_current_child(ChildModel new_child) {
    emit(ChangingCurrentChildState());

    emit(CurrentChildChangedState(new_current_child: new_child));
  }
}
