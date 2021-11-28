

class Notifications {
  final String notificationId;
  final String title;
  final String description;
  bool completed;
  final String type;

  Notifications(
      this.notificationId,
      this.title,
      this.description,
      this.completed,
      this.type,
  );
}