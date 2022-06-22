// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class AddNotificationEvent extends NotificationEvent {
  NotificationModel notification;

  AddNotificationEvent({
    required this.notification,
  });
}

class GetAllNotificationsEvent extends NotificationEvent {}

class GetAllUnopenedNotificationsEvent extends NotificationEvent {}

class DeleteAllNotificationsEvent extends NotificationEvent {}

class GetNotificationEvent extends NotificationEvent {
  int notificationId;
  GetNotificationEvent({required this.notificationId});
}

class DismissNotificationEvent extends NotificationEvent {
  NotificationModel notification;
  DismissNotificationEvent({required this.notification});
}