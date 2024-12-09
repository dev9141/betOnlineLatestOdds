class APIError {
  int status;
  String message;
  dynamic response;

  APIError({required this.response,required this.status, required this.message});
}
