// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notification_bloc.dart';

@immutable
abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialNotificationState extends NotificationState {}

class AddingNotificationState extends NotificationState {}

class AddedNotificationState extends NotificationState {
  final NotificationModel notification;

  AddedNotificationState(this.notification);

  @override
  List<Object?> get props => [notification];
}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadingErrorState extends NotificationState {}

class NotificationLoadedState extends NotificationState {
  final NotificationModel notification;

  NotificationLoadedState(this.notification);

  @override
  List<Object?> get props => [notification];
}

class AllNotificationsLoadingState extends NotificationState {}

class AllNotificationsLoadingErrorState extends NotificationState {}

class AllNotificationsLoadedState extends NotificationState {
  final List<NotificationModel> notifications;

  AllNotificationsLoadedState(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class AllUnopenedNotificationsLoadingState extends NotificationState {}

class AllUnopenedNotificationsLoadingErrorState extends NotificationState {}

class AllUnopenedNotificationsLoadedState extends NotificationState {
  final List<NotificationWithChild> notificationsWihChildren;

  AllUnopenedNotificationsLoadedState(this.notificationsWihChildren);

  @override
  List<Object?> get props => [notificationsWihChildren];
}

class DeleteingAllNotificationsState extends NotificationState {}

class DeletedAllNotificationsState extends NotificationState {}

class DismissingNotificationState extends NotificationState {}

class DismissedNotificationsState extends NotificationState {
  int notificationId;
  DismissedNotificationsState({
    required this.notificationId,
  });
}

class ErrorDismissingNotificationState extends NotificationState {}

class NotificationErrorState extends NotificationState {
  final String error;

  NotificationErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
