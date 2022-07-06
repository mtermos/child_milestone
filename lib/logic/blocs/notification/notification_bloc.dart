import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/constants/tuples.dart';
import 'package:child_milestone/data/models/notification.dart';
import 'package:child_milestone/data/repositories/notification_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc({required this.notificationRepository})
      : super(InitialNotificationState()) {
    on<AddNotificationEvent>(addNotification);
    on<GetAllNotificationsEvent>(getAllNotifications);
    on<DeleteAllNotificationsEvent>(deleteAllNotifications);

    on<GetAllUnopenedNotificationsEvent>(getAllUnopenedNotifications);
    on<GetNotificationEvent>(getNotification);
    on<DismissNotificationEvent>(dismissNotification);
  }

  void addNotification(
      AddNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(AddingNotificationState());
    DaoResponse<bool, int> daoResponse =
        await notificationRepository.insertNotification(event.notification);
    if (daoResponse.item1) {
      emit(AddedNotificationState(event.notification));
    }
  }

  void getAllNotifications(
      GetAllNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(AllNotificationsLoadingState());
    // await notificationRepository.deleteAllNotifications();
    List<NotificationModel>? notifications =
        await notificationRepository.getAllNotifications();
    if (notifications != null) {
      emit(AllNotificationsLoadedState(notifications));
    } else {
      emit(AllNotificationsLoadingErrorState());
    }
  }

  void deleteAllNotifications(DeleteAllNotificationsEvent event,
      Emitter<NotificationState> emit) async {
    emit(DeleteingAllNotificationsState());
    await notificationRepository.deleteAllNotifications();
    emit(DeletedAllNotificationsState());
  }

  void getNotification(
      GetNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoadingState());
    NotificationModel? notification =
        await notificationRepository.getNotificationByID(event.notificationId);
    if (notification != null) {
      emit(NotificationLoadedState(notification));
    } else {
      emit(NotificationLoadingErrorState());
    }
  }

  void getAllUnopenedNotifications(GetAllUnopenedNotificationsEvent event,
      Emitter<NotificationState> emit) async {
    emit(AllUnopenedNotificationsLoadingState());
    // await notificationRepository.deleteAllNotifications();
    List<NotificationWithChildAndMilestone>? notifications =
        await notificationRepository.getAllNotificationsWithChildren();
    if (notifications != null) {
      notifications = notifications
          .where((element) =>
              !element.notification.opened && !element.notification.dismissed)
          .toList();
      emit(AllUnopenedNotificationsLoadedState(notifications));
    } else {
      emit(AllUnopenedNotificationsLoadingErrorState());
    }
  }

  void dismissNotification(
      DismissNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(DismissingNotificationState());
    DaoResponse<bool, int> response =
        await notificationRepository.dismissNotification(event.notification);

    if (response.item1) {
      emit(DismissedNotificationsState(notificationId: event.notification.id));
    } else {
      emit(ErrorDismissingNotificationState());
    }
  }
}
