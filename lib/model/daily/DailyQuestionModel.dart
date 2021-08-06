import 'package:hive/hive.dart';

@HiveType()
class DailyQ {
  @HiveField(0)
  final String sleepTime;

  @HiveField(1)
  final int age;

  DailyQ(this.sleepTime, this.age);
}