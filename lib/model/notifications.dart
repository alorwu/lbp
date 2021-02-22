
// import 'package:floor/floor.dart';

// @Entity(tableName: 'notifications', indices: [Index(value: ["id", "notification_id"], unique: true)])
// class Notifications {
//   @PrimaryKey(autoGenerate: true)
//   @ColumnInfo(name: 'id', nullable: false)
//   final int id;
//
//   @ColumnInfo(name: 'notification_id', nullable: false)
//   final String notificationId;
//
//   @ColumnInfo(name: 'title', nullable: false)
//   final String title;
//
//   @ColumnInfo(name: 'message', nullable: false)
//   final String description;
//
//   @ColumnInfo(name: 'completed', nullable: false)
//   bool completed;
//
//   @ColumnInfo(name: 'timestamp', nullable: false)
//   final String timestamp;
//
//   @ColumnInfo(name: 'date_entered', nullable: false)
//   final String dateEntered;
//
//   Notifications(this.id, this.notificationId, this.title, this.description, this.completed, this.timestamp, this.dateEntered); //, this.data);
// }

class Notifications {
  final String notificationId;
  final String title;
  final String description;
  bool completed;
  final String type;
  // final String timestamp;
  // final String dateEntered;

  Notifications(this.notificationId, this.title, this.description, this.completed, this.type); //, this.timestamp, this.dateEntered); //, this.data);
}