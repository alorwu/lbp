
import 'package:hive/hive.dart';

part 'sleep_component_score.g.dart';

@HiveType(typeId: 4)
class SleepComponentScores {
  @HiveField(0)
  int? sleepQuality;

  @HiveField(1)
  int? sleepLatency;

  @HiveField(2)
  int? sleepDuration;

  @HiveField(3)
  int? sleepEfficiency;

  @HiveField(4)
  int? sleepDisturbance;

  @HiveField(5)
  int? sleepMedication;

  @HiveField(6)
  int? dayTimeDysfunction;

  @HiveField(7)
  int? pSQIScore;

  @HiveField(8)
  DateTime? dateTaken;

  SleepComponentScores({
    this.sleepQuality,
    this.sleepLatency,
    this.sleepDuration,
    this.sleepEfficiency,
    this.sleepDisturbance,
    this.sleepMedication,
    this.dayTimeDysfunction,
    this.pSQIScore,
    this.dateTaken
  });
}