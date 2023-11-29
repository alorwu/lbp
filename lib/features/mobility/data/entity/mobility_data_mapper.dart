import 'package:lbp/features/mobility/data/entity/mobility_data_dto.dart';
import 'package:lbp/features/mobility/domain/entity/mobility_data.dart';

abstract class MobilityDataMapper {
  MobilityData mapResponseToData(MobilityDataResponse response);
}

class MobilityDataMapperImpl extends MobilityDataMapper {

  @override
  MobilityData mapResponseToData(MobilityDataResponse response) {
    return MobilityData(
        date: response.date,
        stepsTaken: response.stepsTaken,
        distanceTravelled: response.distanceTravelled,
    );
  }

}