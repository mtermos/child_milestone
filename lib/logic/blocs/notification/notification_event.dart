// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class AddNotificationEvent extends NotificationEvent {
  final NotificationModel notification;

  const AddNotificationEvent({
    required this.notification,
  });
}

class GetAllNotificationsEvent extends NotificationEvent {}

class GetAllUnopenedNotificationsEvent extends NotificationEvent {}

class DeleteAllNotificationsEvent extends NotificationEvent {}

class GetNotificationEvent extends NotificationEvent {
  final int notificationId;
  const GetNotificationEvent({required this.notificationId});
}

class DismissNotificationEvent extends NotificationEvent {
  final NotificationModel notification;
  const DismissNotificationEvent({required this.notification});
}
