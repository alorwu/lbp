
import '../entity/mobility_data.dart';

abstract class MobilityRepository {
  Future<void> saveMobilityData(MobilityData data);
  Future<MobilityData> getMobilityData(DateTime dateTime);
}