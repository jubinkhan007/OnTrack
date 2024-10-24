import 'package:dio/dio.dart';
import 'package:tmbi/network/custom_interceptor.dart';

class ApiService {
  final _baseUrl = "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/";
  final _receiveTimeout = const Duration(seconds: 30);
  final _connectTimeout = const Duration(seconds: 30);
  final _sendTimeout = const Duration(seconds: 30);

  late Dio _dio;

  //  (_):: before the constructor name indicates that it is private.
  // Singleton Pattern:: only one instance of the class can exist,
  // singleton class will have a static instance & a method to access
  // that instance.
  // _internal():: is a static method that checks if an instance
  // already exists & if not, creates one.

  // private constructor
  ApiService._internal();

  // static variable to hold the singleton instance
  static final ApiService _apiService = ApiService._internal();

  // factory constructor to return the instance
  factory ApiService() {
    return _apiService;
  }

  Dio provideDio() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: _baseUrl,
      receiveTimeout: _receiveTimeout,
      connectTimeout: _connectTimeout,
      sendTimeout: _sendTimeout,
    );

    Interceptor customInterceptor = CustomInterceptor();
    _dio = Dio(baseOptions);
    //_dio.interceptors.addAll({prettyDioLogger, customInterceptor});
    _dio.interceptors.add(customInterceptor);

    return _dio;
  }
}
