
import 'package:flutter/cupertino.dart';
import 'package:lbp/features/mobility/data/entity/mobility_data_mapper.dart';

import '../../domain/entity/mobility_data.dart';
import '../../domain/repository/mobility_repository.dart';
import '../datasource/local_mobility_datasource_impl.dart';
import '../datasource/remote_mobility_datasource_impl.dart';

class MobilityRepositoryImpl extends MobilityRepository {
  final LocalMobilityDataSource  localMobilityDataSource;
  final RemoteMobilityDataSource remoteMobilityDataSource;
  final MobilityDataMapper mobilityDataMapper;

  MobilityRepositoryImpl({
    @required this.localMobilityDataSource,
    @required this.remoteMobilityDataSource,
    @required this.mobilityDataMapper,
  });


  @override
  Future<void> saveMobilityData(MobilityData data) async {
    await localMobilityDataSource.saveMobilityData(data);

    try {
      remoteMobilityDataSource.saveMobilityData(data);
    } on Exception {
      return Exception();
    }
  }

  @override
  Future<MobilityData> getMobilityData(DateTime dateTime) async {
    return mobilityDataMapper.mapResponseToData(
        await localMobilityDataSource.getMobilityData(dateTime)
    );
  }

}