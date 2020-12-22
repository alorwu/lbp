
import 'package:floor/floor.dart';
import 'package:lbp/model/notifications.dart';


@dao
abstract class NotificationDao {
  @Query('SELECT * FROM notifications ORDER BY id DESC')
  Future<List<Notifications>> findAllNotifications();

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<void> insertNotification(Notifications notification);

  @Query('DELETE FROM notifications WHERE id = :id')
  Future<void> delete(int id);

  @Query('SELECT * FROM notifications WHERE notification_id = :notificationId')
  Future<Notifications> findByNotificationId(String notificationId);
}