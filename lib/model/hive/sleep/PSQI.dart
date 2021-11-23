import 'package:hive/hive.dart';

part 'PSQI.g.dart';

@HiveType(typeId: 2)
class PSQI {
  @HiveField(0)
  String timeToBed;

  @HiveField(1)
  String timeToSleep;

  @HiveField(2)
  String wakeUpTime;

  @HiveField(3)
  String hoursSlept;

  @HiveField(4)
  String sleepIn30Mins;

  @HiveField(5)
  String wakeUpNightOrMorning;

  @HiveField(6)
  String bathroomUse;

  @HiveField(7)
  String cannotBreathe;

  @HiveField(8)
  String coughOrSnoreLoudly;

  @HiveField(9)
  String feelCold;

  @HiveField(10)
  String feelHot;

  @HiveField(11)
  String badDreams;

  @HiveField(12)
  String havePain;

  @HiveField(13)
  String otherReasonsUnableToSleep;

  @HiveField(14)
  String troubleSleepingDueToOtherReason;

  @HiveField(15)
  String sleepQuality;

  @HiveField(16)
  String medicineToSleep;

  @HiveField(17)
  String troubleStayingAwake;

  @HiveField(18)
  String enthusiasm;

  @HiveField(19)
  String partnerOrRoommate;

  @HiveField(20)
  String loudSnoring;

  @HiveField(21)
  String pausesInBreath;

  @HiveField(22)
  String legTwitching;

  @HiveField(23)
  String disorientation;

  @HiveField(24)
  String restlessnessInSleep;

  @HiveField(25)
  String numberOfTimesOfRestlessness;

  @HiveField(26)
  DateTime dateTaken;

  PSQI({
    this.timeToBed,
    this.timeToSleep,
    this.wakeUpTime,
    this.hoursSlept,
    this.sleepIn30Mins,
    this.wakeUpNightOrMorning,
    this.bathroomUse,
    this.cannotBreathe,
    this.coughOrSnoreLoudly,
    this.feelCold,
    this.feelHot,
    this.badDreams,
    this.havePain,
    this.otherReasonsUnableToSleep,
    this.troubleSleepingDueToOtherReason,
    this.sleepQuality,
    this.medicineToSleep,
    this.troubleStayingAwake,
    this.enthusiasm,
    this.partnerOrRoommate,
    this.loudSnoring,
    this.pausesInBreath,
    this.legTwitching,
    this.disorientation,
    this.restlessnessInSleep,
    this.numberOfTimesOfRestlessness,
    this.dateTaken,
  });
}