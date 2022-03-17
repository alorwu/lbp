import 'package:hive/hive.dart';

@HiveType(typeId: 6)
class MobilityDataResponse {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int numberOfStops;

  @HiveField(2)
  int numberOfMoves;

  @HiveField(3)
  int numberOfSignificantPlaces;
}
