import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:lbp/core/notification_repository.dart';
import 'package:lbp/core/notification_repository_impl.dart';
import 'package:lbp/domain/entity/questionnaires/auction/auction_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../data/entity/notification/firebase_notification.dart';
import '../env/.env.dart';


class NotificationModel extends ChangeNotifier {
  FirebaseNotification? _notification;
  NotificationRepository repository = NotificationRepositoryImpl();

  Future<FirebaseNotification?> loadAvailableNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var todayAuctionTaken = preferences.getString("auction_taken_date");
    // if (todayAuctionTaken != DateFormat("yyyy-MM-dd").format(DateTime.now())) {
    //   if (_notification == null) {
        await getAuctionFromRemoteDb();
      // } else {
      //   var json = jsonEncode(_notification);
      //   await preferences.setString("push", json);
      // }
    // }
    return _notification;
  }

  Future<void> getAuctionFromRemoteDb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString('app_id');

    final response = await http.get(
      Uri.parse('${environment['remote_url']}/api/auctions/today/auction/$deviceId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );
    if (response.statusCode.toString().startsWith("2")) {
      AuctionNotificationDto dto = AuctionNotificationDto.fromJson(jsonDecode(response.body));
      var data = Data(
        auctionId: dto.auctionId,
        sleepDuration: dto.sleepDuration,
        sleepQuality: dto.qualityOfSleep,
        painIntensity: dto.painIntensity,
        numberOfWakeupTimes: dto.numberOfWakeupTimes,
      );

      var firebaseNotification = FirebaseNotification(
        messageId: null,
        title: dto.title,
        body: dto.description,
        ttl: null,
        sentTime: DateTime.parse(dto.createdAt!).millisecondsSinceEpoch,
        data: data
      );

      await saveNotificationWithSharedPreferences(firebaseNotification);
      // loadAvailableNotification();
      notifyListeners();
    }
    notifyListeners();
  }

  FirebaseNotification? get notification {
    getNotificationFromSharedPreferences();
    return _notification;
  }

  Future<void> getNotificationFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var pushString = preferences.getString("push");
    if (pushString != null && pushString != null.toString()) {
      _notification = FirebaseNotification.fromJson(jsonDecode(pushString));
      notifyListeners();
    } else {
      _notification = null;
    }
    return null;
  }

  Future<void> deleteNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    await preferences.setString('auction_taken_date', date);
    var dt = preferences.getString('auction_taken_date');
    await preferences.remove("push");
    // await NotificationRepositoryImpl().deleteNotification();
    _notification = null;
    notifyListeners();
  }

  Future<void> saveFirebaseNotification(RemoteMessage message) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();

    var isAuction = message.data.containsKey("auctionId");
    if (isAuction) {
      FirebaseNotification firebaseNotification = FirebaseNotification(
          messageId: message.messageId,
          title: message.notification?.title,
          body: message.notification?.body,
          sentTime: message.sentTime?.millisecondsSinceEpoch,
          data: Data.fromJson(message.data));
      // repository.saveNotification(firebaseNotification);

      saveNotificationWithSharedPreferences(firebaseNotification);
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> saveNotificationWithSharedPreferences(FirebaseNotification notification) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var todayAuctionTaken = preferences.getString("auction_taken_date");
    if (todayAuctionTaken != DateFormat("yyyy-MM-dd").format(DateTime.now())) {
      var json = jsonEncode(notification);
      await preferences.setString("push", json);
    }
    notifyListeners();
  }
}