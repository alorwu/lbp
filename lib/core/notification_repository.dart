import 'package:lbp/data/entity/notification/firebase_notification.dart';
import 'package:lbp/features/pushnotification/domain/entity/one_signal_push_notification.dart';

import '../data/entity/notification/notification_entity.dart';

abstract class NotificationRepository {
  Future<FirebaseNotification?> loadNotification();
  // Future<void> initializeOneSignal();
  Future<void> deleteNotification();
  Future<void> saveNotification(FirebaseNotification notification);
}