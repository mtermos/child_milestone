class DaoResponse<T1, T2> {
  final T1 item1;
  final T2 item2;

  const DaoResponse(this.item1, this.item2);
}

class NotificationWithChild<NotificationModel, ChildModel> {
  final NotificationModel notification;
  final ChildModel child;

  const NotificationWithChild(this.notification, this.child);
}
