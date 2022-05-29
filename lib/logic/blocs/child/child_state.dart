part of 'child_bloc.dart';

@immutable
abstract class ChildState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialChildState extends ChildState {}

class AddingChildState extends ChildState {}

class AddedChildState extends ChildState {}

class ChildLoadingState extends ChildState {}

class ChildLoadedState extends ChildState {
  final List<ChildModel> children;

  ChildLoadedState(this.children);

  @override
  List<Object?> get props => [children];
}

class AllChildrenLoadingState extends ChildState {}

class AllChildrenLoadedState extends ChildState {
  final List<ChildModel> children;

  AllChildrenLoadedState(this.children);

  @override
  List<Object?> get props => [children];
}

class DeleteingAllChildrenState extends ChildState {}

class DeletedAllChildrenState extends ChildState {}

class ChildErrorState extends ChildState {
  final String error;

  ChildErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
