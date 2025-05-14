import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:map/core/error/failure.dart';
import 'package:map/core/models/location_model.dart';
import 'package:map/core/models/message_model.dart';
import 'package:map/core/network/api_client.dart';
import 'package:map/core/network/endpoint.dart';
import 'package:map/features/map/domain/repository/map_repository.dart';

class MapRepositoryImpl implements MapRepository{
  @override
  Future<Either<Failure, MessageModel>> postLocation(Location body) async{
    // TODO: implement postLocation

    print(body);
    print(body.toJson());
    final res = await ApiClient().postMethod(
      path: Endpoint.LOCATIONS,
      isHeader: true,
      body: body.toJson(), // Pass the Map here instead of the JSON string
    );

    print("======================================================${res.response}");

    if (res.isSuccess) {
      try {

        MessageModel result = MessageModel.fromJson(res.response);
        print("======================================================");
        return Right(result);
      } catch (e) {

        return Left(Failure(message: "error $e"));
      }
    }
    return Left(Failure(message: res.response.toString()));
  }

}