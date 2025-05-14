import 'package:dartz/dartz.dart';
import 'package:map/core/error/failure.dart';
import 'package:map/core/models/location_model.dart';
import 'package:map/core/models/message_model.dart';
import 'package:map/core/no_param.dart';
import 'package:map/core/usecase/usecase.dart';
import 'package:map/features/map/domain/repository/map_repository.dart';

class MapUseCase extends UseCase<MessageModel, Location>{
  final MapRepository repositoryImpl;
  MapUseCase(this.repositoryImpl);

  @override
  Future<Either<Failure, MessageModel>> call(Location params) async {
    return await repositoryImpl.postLocation(params);
  }
}