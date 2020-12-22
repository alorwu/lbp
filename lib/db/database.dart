import 'dart:async';
import 'package:floor/floor.dart';
import 'package:lbp/dao/notification_dao.dart';
import 'package:lbp/model/notifications.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part 'database.g.dart';

@Database(version: 1, entities: [Notifications])
abstract class AppDatabase extends FloorDatabase {
  NotificationDao get notificationDao;
}