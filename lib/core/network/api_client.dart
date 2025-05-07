
import 'package:dio/dio.dart';


import 'api_client_model.dart';
import 'endpoint.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    validateStatus: (status) {
      return status != null &&
          status <
              500; // 500 dan kichik status kodlarini error deb hisoblamaydi
    },
  ));

  // header
  Map<String, dynamic> header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };



  Future<ApiClientModel> postMethod(
      {required String path,
        required bool isHeader,
        required Map<String, dynamic>? body}) async {
    try {
      final res = await _dio.post(
        Endpoint.BASE + path,
        data: body,
        options: Options(
          headers: isHeader ? header : null,
        ),
      );
      return _handleResponse(res);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }




  // success response method
  ApiClientModel _handleResponse(Response res) {
    if (res.statusCode! >= 200 && res.statusCode! < 300) {
      return ApiClientModel(
          errorCode: res.statusCode, response: res.data, isSuccess: true);
    }
    return ApiClientModel(
        errorCode: res.statusCode, response: res.data, isSuccess: false);
  }
  // error response method
  ApiClientModel _handleError(DioException e) {

    return ApiClientModel(
      errorCode: e.response?.statusCode ?? 0,
      response: e.response?.data ?? "Unknown error",
      isSuccess: false,
    );
  }


}