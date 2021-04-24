class ApiError {
  String error;

  ApiError(this.error);


  ApiError.fromJson(Map<String, dynamic> json) {
   error = 'Unexpected Exception: ${json['message']}';
  }

}