part of 'current_child_cubit.dart';

@immutable
abstract class CurrentChildState extends Equatable {
  @override
  List<Object> get props => [];
}

class NoCurrentChildState extends CurrentChildState {}

class ChangingCurrentChildState extends CurrentChildState {}

class CurrentChildChangedState extends CurrentChildState {
  ChildModel new_current_child;

  CurrentChildChangedState({
    required this.new_current_child,
  });

  @override
  List<Object> get props => [new_current_child];
}