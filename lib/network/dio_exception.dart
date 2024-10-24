import 'package:dio/dio.dart';

import '../config/strings.dart';

class TimeoutException extends DioException {
  TimeoutException({required super.requestOptions});

  @override
  String toString() {
    return Strings.connection_timeout;
  }
}

class UnknownErrorException extends DioException {
  UnknownErrorException({required super.requestOptions});

  @override
  String toString() {
    return Strings.unknown_error_occured;
  }
}

class NoInternetException extends DioException {
  NoInternetException({required super.requestOptions});

  @override
  String toString() {
    return Strings.no_internet_connection;
  }
}
