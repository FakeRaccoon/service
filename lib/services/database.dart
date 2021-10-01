import 'package:dio/dio.dart';

class ErrorHandling {
  static Future throwError(DioError error) {
    if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.sendTimeout ||
        error.type == DioErrorType.receiveTimeout) {
      throw 'Connection Timeout';
    } else if (error.type == DioErrorType.response) {
      if (error.response!.statusCode == 401) {
        throw 'Username atau Password anda salah';
      } else {
        throw error.message;
      }
    } else {
      print(error);
      throw 'Error';
    }
  }
}
