// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'child_bloc.dart';

@immutable
abstract class ChildEvent extends Equatable {
  const ChildEvent();
  @override
  List<Object> get props => [];
}

class AddChildEvent extends ChildEvent {
  ChildModel child;

  AddChildEvent({
    required this.child,
  });
}

class GetAllChildrenEvent extends ChildEvent {}

class DeleteAllChildrenEvent extends ChildEvent {}

class GetChildEvent extends ChildEvent {
  String child_id;
  GetChildEvent({required this.child_id});
}
