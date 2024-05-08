class NetworkResponse{
  final int statusCode;
  final bool isSuccess;
  final Map<String,dynamic>? body;
  NetworkResponse(this.statusCode, this.isSuccess, this.body);
}