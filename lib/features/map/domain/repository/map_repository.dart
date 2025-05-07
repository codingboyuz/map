import 'package:dartz/dartz.dart';
import 'package:map/core/error/failure.dart';
import 'package:map/core/models/location_model.dart';

abstract class MapRepository{
  Future<Either<Failure,Location>> postLocation(Location body);
}