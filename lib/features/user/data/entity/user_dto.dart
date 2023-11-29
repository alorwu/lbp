
import 'package:hive/hive.dart';

part 'user_dto.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? token;

  @HiveField(2)
  String? nickname;

  @HiveField(3)
  String? date;

  @HiveField(4)
  String? segment;


  User({
    this.id,
    this.token,
    this.nickname,
    this.date,
    this.segment,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'nickname': nickname,
      'segment': segment,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    segment = json['segment'];
  }

}