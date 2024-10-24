import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tmbi/models/user_response.dart';

class LoginRepo {
  final Dio dio;

  LoginRepo({
    required this.dio,
  });

  Future<UserResponse> userAuth(String userid, String password) async {
    try {
      final headers = {
        'vm': 'LOGIN',
        'va': '5',
        'vb': userid,
        'vc': password,
        'vd': 'user',
      };
      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );
      return UserResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }
}
