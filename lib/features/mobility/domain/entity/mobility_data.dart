
import 'package:hive/hive.dart';
part 'mobility_data.g.dart';

@HiveType(typeId: 8)
class MobilityData {
  @HiveField(0)
  final DateTime? date;
  @HiveField(1)
  final int? stepsTaken;

  MobilityData({
    this.date,
    this.stepsTaken,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'stepsTaken': stepsTaken,
    };
  }
}