class PushNotification {
  String googleDeliveredPriority;
  int googleSentTime;
  int googleTtl;
  String googleOriginalPriority;
  Custom custom;
  String othChnl;
  String grp;
  String pri;
  String vis;
  String from;
  String alert;
  String title;
  String grpMsg;
  String googleMessageId;
  String googleCSenderId;
  int androidNotificationId;

  PushNotification(
      {this.googleDeliveredPriority,
        this.googleSentTime,
        this.googleTtl,
        this.googleOriginalPriority,
        this.custom,
        this.othChnl,
        this.grp,
        this.pri,
        this.vis,
        this.from,
        this.alert,
        this.title,
        this.grpMsg,
        this.googleMessageId,
        this.googleCSenderId,
        this.androidNotificationId});

  PushNotification.fromJson(Map<String, dynamic> json) {
    googleDeliveredPriority = json['google.delivered_priority'];
    googleSentTime = json['google.sent_time'];
    googleTtl = json['google.ttl'];
    googleOriginalPriority = json['google.original_priority'];
    custom =
    json['custom'] != null ? new Custom.fromJson(json['custom']) : null;
    othChnl = json['oth_chnl'];
    grp = json['grp'];
    pri = json['pri'];
    vis = json['vis'];
    from = json['from'];
    alert = json['alert'];
    title = json['title'];
    grpMsg = json['grp_msg'];
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
    if (this.custom != null) {
      data['custom'] = this.custom.toJson();
    }
    data['oth_chnl'] = this.othChnl;
    data['grp'] = this.grp;
    data['pri'] = this.pri;
    data['vis'] = this.vis;
    data['from'] = this.from;
    data['alert'] = this.alert;
    data['title'] = this.title;
    data['grp_msg'] = this.grpMsg;
    data['google.message_id'] = this.googleMessageId;
    data['google.c.sender.id'] = this.googleCSenderId;
    data['androidNotificationId'] = this.androidNotificationId;
    return data;
  }
}

class Custom {
  A a;
  String i;

  Custom({this.a, this.i});

  Custom.fromJson(Map<String, dynamic> json) {
    a = json['a'] != null ? new A.fromJson(json['a']) : null;
    i = json['i'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.a != null) {
      data['a'] = this.a.toJson();
    }
    data['i'] = this.i;
    return data;
  }
}

class A {
  Q q1;
  Q q2;

  A({this.q1, this.q2});

  A.fromJson(Map<String, dynamic> json) {
    q1 = json['q1'] != null ? new Q.fromJson(json['q1']) : null;
    q2 = json['q2'] != null ? new Q.fromJson(json['q2']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.q1 != null) {
      data['q1'] = this.q1.toJson();
    }
    if (this.q2 != null) {
      data['q2'] = this.q2.toJson();
    }
    return data;
  }
}

class Q {
  String question;
  List<String> options;

  Q({this.question, this.options});

  Q.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['options'] = this.options;
    return data;
  }
}