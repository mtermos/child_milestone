part of 'child_bloc.dart';

@immutable
abstract class ChildState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialChildState extends ChildState {}

class AddingChildState extends ChildState {}

class ErrorAddingChildState extends ChildState {}

class ErrorAddingChildUniqueIDState extends ChildState {}

class AddedChildState extends ChildState {
  final ChildModel child;

  AddedChildState(this.child);

  @override
  List<Object?> get props => [child];
}

class EditingChildState extends ChildState {}

class ErrorEditingChildState extends ChildState {}

class EditedChildState extends ChildState {
  final ChildModel child;

  EditedChildState(this.child);

  @override
  List<Object?> get props => [child];
}

class ChildLoadingState extends ChildState {}

class ChildLoadingErrorState extends ChildState {}

class ChildLoadedState extends ChildState {
  final ChildModel child;

  ChildLoadedState(this.child);

  @override
  List<Object?> get props => [child];
}

class AllChildrenLoadingState extends ChildState {}

class AllChildrenLoadingErrorState extends ChildState {}

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

class DeletingChildState extends ChildState {}

class ErrorDeletingChildState extends ChildState {}

class DeletedChildState extends ChildState {}

class UploadingChildrenState extends ChildState {}

class ErrorUploadingChildrenState extends ChildState {
  final String error;
  ErrorUploadingChildrenState({
    required this.error,
  });
}

class UploadedChildrenState extends ChildState {}
