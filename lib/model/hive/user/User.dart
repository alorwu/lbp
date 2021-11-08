
import 'package:hive/hive.dart';
part 'User.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String username;

  @HiveField(1)
  int age;

  @HiveField(2)
  String gender;

  @HiveField(3)
  String employment;

  @HiveField(4)
  String academic;

  @HiveField(5)
  double activeLifeStyleLevel;

  @HiveField(6)
  String hasHadLowBackPain;

  @HiveField(7)
  String sciatica;

  @HiveField(8)
  String painIntensity;

  @HiveField(9)
  String hasHadBackSurgery;

  @HiveField(10)
  String hasHadLbpFor;

  @HiveField(11)
  String diagnosedOfLbp;

  @HiveField(12)
  String lbpTreatment;

  @HiveField(13)
  String date;

  User({
    this.username,
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
    this.date
  });

}