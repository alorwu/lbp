
import 'package:hive/hive.dart';
part 'User.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String deviceId;

  @HiveField(1)
  String oneSignalId;

  @HiveField(2)
  String nickname;

  @HiveField(3)
  int age;

  @HiveField(4)
  String gender;

  @HiveField(5)
  String employment;

  @HiveField(6)
  String academic;

  @HiveField(7)
  double activeLifeStyleLevel;

  @HiveField(8)
  String hasHadLowBackPain;

  @HiveField(9)
  String sciatica;

  @HiveField(10)
  String painIntensity;

  @HiveField(11)
  String hasHadBackSurgery;

  @HiveField(12)
  String hasHadLbpFor;

  @HiveField(13)
  String diagnosedOfLbp;

  @HiveField(14)
  String lbpTreatment;

  @HiveField(15)
  String date;

  @HiveField(16)
  String segment;


  User({
    this.deviceId,
    this.oneSignalId,
    this.nickname,
    this.age,
    this.gender,
    this.employment,
    this.academic,
    this.activeLifeStyleLevel,
    this.hasHadLowBackPain,
    this.sciatica,
    this.painIntensity,
    this.hasHadBackSurgery,
    this.hasHadLbpFor,
    this.diagnosedOfLbp,
    this.lbpTreatment,
    this.date,
    this.segment,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': deviceId,
      'playerId': oneSignalId,
      'nickname': nickname,
      'age': age,
      'gender': gender,
      'employment': employment,
      'academic': academic,
      'activeLifeStyleLevel': activeLifeStyleLevel,
      'hasHadLowBackPain': hasHadLowBackPain,
      'sciatica': sciatica,
      'painIntensity': painIntensity,
      'hasHadBackSurgery': hasHadBackSurgery,
      'hasHadLbpFor': hasHadLbpFor,
      'diagnosedOfLbp': diagnosedOfLbp,
      'lbpTreatment': lbpTreatment,
      'segment': segment,
    };
  }


}