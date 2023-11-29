import 'package:hive_flutter/adapters.dart';
import 'package:lbp/core/notification_repository.dart';
import 'package:lbp/data/entity/notification/firebase_notification.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  @override
  Future<FirebaseNotification?> loadNotification() {
    return getNotification();
  }

  Future<FirebaseNotification?> getNotification() async {
    Box<FirebaseNotification> box = Hive.box("notificationBox");
    // if (isBoxOpened) {
    //   box = Hive.box<FirebaseNotification>("notificationBox");
    // } else {
    //   box = await Hive.openBox<FirebaseNotification>("notificationBox");
    // }
    var value = box.get("notification");
    return value;
  }

  Future<void> saveNotification(FirebaseNotification notification) async {
    // await Hive.initFlutter();
    Box<FirebaseNotification> box = Hive.box("notificationBox");
    // var isBoxOpened = Hive.isBoxOpen("notificationBox");
    // if (isBoxOpened) {
    //   box = Hive.box<FirebaseNotification>("notificationBox");
    // } else {
    //   box = await Hive.openBox<FirebaseNotification>("notificationBox");
    // }
    await box.put("notification", notification);

    loadNotification();
  }

  @override
  Future<void> deleteNotification() async {
    Box<FirebaseNotification> box = Hive.box("notificationBox");
    // if (isBoxOpened) {
    //   box = Hive.box<FirebaseNotification>("notificationBox");
    // } else {
    //   box = await Hive.openBox<FirebaseNotification>("notificationBox");
    // }
    await box.delete("notification");

    loadNotification();
  }
}