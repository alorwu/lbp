import 'package:hive/hive.dart';

part 'firebase_notification.g.dart';

@HiveType(typeId: 7)
class FirebaseNotification {
  @HiveField(0)
  String? messageId;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? body;

  @HiveField(3)
  int? sentTime;

  @HiveField(4)
  int? ttl;

  @HiveField(5)
  Data? data;

  FirebaseNotification({
    this.messageId,
    this.title,
    this.body,
    this.sentTime,
    this.ttl,
    this.data
  });

  FirebaseNotification.fromJson(Map<String, dynamic> json) {
    messageId = json['messageId'];
    title = json['title'];
    body = json['body'];
    sentTime = json['sentTime'];
    ttl = json['ttl'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageId'] = this.messageId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['sentTime'] = this.sentTime;
    data['ttl'] = this.ttl;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? auctionId;
  String? sleepDuration;
  String? sleepQuality;
  String? painIntensity;
  String? numberOfWakeupTimes;

  Data({
    this.auctionId,
    this.sleepDuration,
    this.sleepQuality,
    this.painIntensity,
    this.numberOfWakeupTimes
  });

  Data.fromJson(Map<String, dynamic> json) {
    auctionId = json['auctionId'];
    sleepDuration = json['SLEEP_DURATION'];
    sleepQuality = json['SLEEP_QUALITY'];
    painIntensity = json['PAIN_INTENSITY'];
    numberOfWakeupTimes = json['NUMBER_OF_WAKEUP_TIMES'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auctionId'] = this.auctionId;
    data['SLEEP_DURATION'] = this.sleepDuration;
    data['SLEEP_QUALITY'] = this.sleepQuality;
    data['PAIN_INTENSITY'] = this.painIntensity;
    data['NUMBER_OF_WAKEUP_TIMES'] = this.numberOfWakeupTimes;
    return data;
  }
}