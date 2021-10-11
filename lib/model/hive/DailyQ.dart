
import 'package:hive/hive.dart';
part 'DailyQ.g.dart';

@HiveType(typeId: 0)
class DailyQ {
  @HiveField(0)
  DateTime dateTaken;

  @HiveField(1)
  DateTime sleepTime;

  @HiveField(2)
  DateTime wakeupTime;

  @HiveField(3)
  String timeToSleep;

  @HiveField(4)
  int numberOfWakeupTimes;

  @HiveField(5)
  String wellRestedness;

  @HiveField(6)
  int qualityOfSleep;

  @HiveField(7)
  int painIntensity;

  @HiveField(8)
  String notes;

  DailyQ({
    this.dateTaken,
    this.sleepTime,
    this.wakeupTime,
    this.timeToSleep,
    this.numberOfWakeupTimes,
    this.wellRestedness,
    this.qualityOfSleep,
    this.painIntensity,
    this.notes
  });

}

extension DailyQExtension on DailyQ {
  get sleepPeriod {
    return durationToList(differenceInSleep(this));
  }
}

List<String> durationToList(int minutes) {
  return Duration(minutes:minutes).toString().split(':');
}

int differenceInSleep(DailyQ q) {
  return q.wakeupTime.difference(q.sleepTime).inMinutes;
}

extension DailyListExtension on List<DailyQ> {
  get averageSleepScore {
    return this.map((e) => e.qualityOfSleep).reduce((value, element) => value + element)/this.length;
  }

  get averageSleepPeriod {
    int min = (this.map((e) => differenceInSleep(e)).reduce((value, element) => value + element)/this.length).round();
    return durationToList(min);
  }
}