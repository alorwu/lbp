
import 'package:hive/hive.dart';

part 'quality_of_life_score.g.dart';

@HiveType(typeId: 5)
class QoLScore {
  @HiveField(0)
  int physicalHealth;

  @HiveField(1)
  int mentalHealth;

  @HiveField(2)
  DateTime dateTaken;

  QoLScore({
    this.physicalHealth,
    this.mentalHealth,
    this.dateTaken
  });
}