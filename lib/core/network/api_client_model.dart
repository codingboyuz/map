class ApiClientModel {
  final int? errorCode;
  final dynamic response;
  final bool isSuccess;

  ApiClientModel(
      {required this.errorCode,
        required this.response,
        required this.isSuccess});
}