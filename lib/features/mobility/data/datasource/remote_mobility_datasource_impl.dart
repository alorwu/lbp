

import '../../domain/entity/mobility_data.dart';

abstract class RemoteMobilityDataSource {
  Future<void> saveMobilityData(MobilityData data);
}

class RemoteMobilityDataSourceImpl extends RemoteMobilityDataSource {

  @override
  Future<void> saveMobilityData(MobilityData data) {
    // TODO: implement saveMobilityData
    throw UnimplementedError();
  }

}