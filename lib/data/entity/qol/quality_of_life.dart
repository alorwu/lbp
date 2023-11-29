
import 'package:hive/hive.dart';

part 'quality_of_life.g.dart';

@HiveType(typeId: 3)
class QoL {
  @HiveField(0)
  String? generalHealth;

  @HiveField(1)
  String? qualityOfLife;

  @HiveField(2)
  String? physicalHealth;

  @HiveField(3)
  String? mentalHealth;

  @HiveField(4)
  String? socialSatisfaction;

  @HiveField(5)
  String? carryOutSocialActivities;

  @HiveField(6)
  String? carryOutPhysicalActivities;

  @HiveField(7)
  String? emotionalProblems;

  @HiveField(8)
  String? fatigue;

  @HiveField(9)
  String? pain;

  @HiveField(10)
  DateTime? dateTaken;

  QoL({
    this.generalHealth,
    this.qualityOfLife,
    this.physicalHealth,
    this.mentalHealth,
    this.socialSatisfaction,
    this.carryOutSocialActivities,
    this.carryOutPhysicalActivities,
    this.emotionalProblems,
    this.fatigue,
    this.pain,
    this.dateTaken
  });
}