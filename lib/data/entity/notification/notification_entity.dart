
import 'package:hive/hive.dart';

// @HiveType(typeId: 6)
class NotificationEntity {
  @HiveField(0)
  String? googleDeliveredPriority;

  @HiveField(1)
  int? googleSentTime;

  @HiveField(2)
  int? googleTtl;

  @HiveField(3)
  String? googleOriginalPriority;

  @HiveField(4)
  String? custom;

  @HiveField(5)
  String? pri;

  @HiveField(6)
  String? vis;

  @HiveField(7)
  String? from;

  @HiveField(8)
  String? alert;

  @HiveField(9)
  String? title;

  @HiveField(10)
  String? googleMessageId;

  @HiveField(11)
  String? googleCSenderId;

  @HiveField(12)
  int? androidNotificationId;

  NotificationEntity({this.googleDeliveredPriority,
    this.googleSentTime,
    this.googleTtl,
    this.googleOriginalPriority,
    this.custom,
    this.pri,
    this.vis,
    this.from,
    this.alert,
    this.title,
    this.googleMessageId,
    this.googleCSenderId,
    this.androidNotificationId
  });

  NotificationEntity.fromJson(Map<String, dynamic> json) {
    googleDeliveredPriority = json['google.delivered_priority'];
    googleSentTime = json['google.sent_time'];
    googleTtl = json['google.ttl'];
    googleOriginalPriority = json['google.original_priority'];
    custom = json['custom'];
    pri = json['pri'];
    vis = json['vis'];
    from = json['from'];
    alert = json['alert'];
    title = json['title'];
    googleMessageId = json['google.message_id'];
    googleCSenderId = json['google.c.sender.id'];
    androidNotificationId = json['androidNotificationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['google.delivered_priority'] = this.googleDeliveredPriority;
    data['google.sent_time'] = this.googleSentTime;
    data['google.ttl'] = this.googleTtl;
    data['google.original_priority'] = this.googleOriginalPriority;
    data['custom'] = this.custom;
    data['pri'] = this.pri;
    data['vis'] = this.vis;
    data['from'] = this.from;
    data['alert'] = this.alert;
    data['title'] = this.title;
    data['google.message_id'] = this.googleMessageId;
    data['google.c.sender.id'] = this.googleCSenderId;
    data['androidNotificationId'] = this.androidNotificationId;
    return data;
  }
}