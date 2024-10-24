import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tmbi/network/dio_exception.dart';

class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /*var accessToken = sessionManager.getToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }*/
    debugPrint('\n\n--- Request ---');
    debugPrint('Method: ${options.method}');
    debugPrint('URL: ${options.uri}');
    debugPrint('Headers: ${options.headers}');
    debugPrint('Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('\n\n--- Response ---');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(requestOptions: err.requestOptions);
      case DioExceptionType.connectionError:
        throw NoInternetException(requestOptions: err.requestOptions);
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        throw UnknownErrorException(requestOptions: err.requestOptions);
    }
  }
}
