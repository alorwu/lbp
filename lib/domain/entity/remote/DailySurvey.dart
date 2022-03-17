import 'package:uuid/uuid.dart';

class DailySurvey {
  DateTime sleepTime;
  DateTime wakeupTime;
  int numberOfWakeupTimes;
  int qualityOfSleep;
  int painIntensity;
  String painSleepRelationship;
  String notes;
  String sleepDuration;
  DateTime dateTaken;
  String userId;

  DailySurvey({
    this.sleepTime,
    this.wakeupTime,
    this.numberOfWakeupTimes,
    this.qualityOfSleep,
    this.painIntensity,
    this.painSleepRelationship,
    this.notes,
    this.sleepDuration,
    this.dateTaken,
    this.userId
  });

  Map<String, dynamic> toJson() {
    return {
      'sleepTime': sleepTime.toIso8601String(),
      'wakeupTime': wakeupTime.toIso8601String(),
      'numberOfWakeupTimes': numberOfWakeupTimes,
      'qualityOfSleep': qualityOfSleep,
      'painIntensity': painIntensity,
      'painSleepRelationship': painSleepRelationship,
      'notes': notes,
      'sleepDuration': sleepDuration,
      'dateTaken': dateTaken.toIso8601String(),
      'userId': userId
    };
  }

}