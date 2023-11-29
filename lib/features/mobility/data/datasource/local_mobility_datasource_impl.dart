
import 'package:hive/hive.dart';
import 'package:lbp/features/mobility/data/entity/mobility_data_dto.dart';

import '../../domain/entity/mobility_data.dart';

abstract class LocalMobilityDataSource {
  Future<void> saveMobilityData(MobilityData data);
  Future<MobilityDataResponse> getMobilityData(DateTime dateTime);
}

class LocalMobilityDataSourceImpl extends LocalMobilityDataSource {
  String _boxName = "mobilityDataBox";
  late Box<MobilityDataResponse> box;

  LocalMobilityDataSourceImpl() {
    initBox();
  }

  void initBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      box = Hive.box(_boxName);
    } else {
      box =  await Hive.openBox(_boxName);
    }
  }

  @override
  Future<MobilityDataResponse> getMobilityData(DateTime dateTime) async {
    return box.values.where((element) => element.date!.isBefore(dateTime)).first;
  }

  @override
  Future<void> saveMobilityData(MobilityData data) async {
    // await box.put("mobility_data", data);
  }

}