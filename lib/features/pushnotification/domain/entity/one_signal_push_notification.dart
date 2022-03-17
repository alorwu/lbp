
class OneSignalPushNotification {
  String googleDeliveredPriority;
  int googleSentTime;
  int googleTtl;
  String googleOriginalPriority;
  // String custom;
  String pri;
  String vis;
  String from;
  String alert;
  String title;
  String googleMessageId;
  String googleCSenderId;
  int androidNotificationId = 0;

  OneSignalPushNotification(
      {this.googleDeliveredPriority,
        this.googleSentTime,
        this.googleTtl,
        this.googleOriginalPriority,
        // this.custom,
        this.pri,
        this.vis,
        this.from,
        this.alert,
        this.title,
        this.googleMessageId,
        this.googleCSenderId,
        this.androidNotificationId
      });

  OneSignalPushNotification.fromJson(Map<String, dynamic> json) {
    googleDeliveredPriority = json['google.delivered_priority'];
    googleSentTime = json['google.sent_time'];
    googleTtl = json['google.ttl'];
    googleOriginalPriority = json['google.original_priority'];
    // custom = json['custom'];
    pri = json['pri'];
    vis = json['vis'];
    from = json['from'];
    alert = json['alert'];
    title = json['title'];
    googleMessageId = json['google.message_id'];
    googleCSenderId = json['google.c.sender.id'];
    androidNotificationId = json['androidNotificationId'] != null ? json['androidNotificationId'] : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['google.delivered_priority'] = this.googleDeliveredPriority;
    data['google.sent_time'] = this.googleSentTime;
    data['google.ttl'] = this.googleTtl;
    data['google.original_priority'] = this.googleOriginalPriority;
    // data['custom'] = this.custom;
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
