// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'child_bloc.dart';

@immutable
abstract class ChildEvent extends Equatable {
  const ChildEvent();
  @override
  List<Object> get props => [];
}

class AddChildEvent extends ChildEvent {
  final BuildContext context;
  final ChildModel child;
  final bool addNotifications;
  final Function whenDone;

  const AddChildEvent({
    required this.context,
    required this.child,
    required this.addNotifications,
    required this.whenDone,
  });
}

class EditChildEvent extends ChildEvent {
  final BuildContext context;
  final ChildModel child;
  final bool addNotifications;
  final Function whenDone;

  const EditChildEvent({
    required this.context,
    required this.child,
    required this.addNotifications,
    required this.whenDone,
  });
}

class GetAllChildrenEvent extends ChildEvent {}

class DeleteAllChildrenEvent extends ChildEvent {}

class GetChildEvent extends ChildEvent {
  final int id;
  const GetChildEvent({required this.id});
}

class DeleteChildEvent extends ChildEvent {
  final int id;
  const DeleteChildEvent({required this.id});
}
