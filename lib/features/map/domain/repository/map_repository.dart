import 'package:dartz/dartz.dart';
import 'package:map/core/error/failure.dart';
import 'package:map/core/models/location_model.dart';
import 'package:map/core/models/message_model.dart';

abstract class MapRepository{
  Future<Either<Failure,MessageModel>> postLocation(Location body);
}