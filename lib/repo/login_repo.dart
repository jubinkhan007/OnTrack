import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tmbi/models/user_response.dart';

class LoginRepo {
  final Dio dio;

  LoginRepo({
    required this.dio,
  });

  Future<UserResponse> userAuth(
      String userid, String password, String? firebaseDeviceToken) async {
    final packageInfo = await PackageInfo.fromPlatform();
    try {
      final headers = {
        'vm': 'LOGIN',
        'va': firebaseDeviceToken != null
            ? "${packageInfo.buildNumber}#$firebaseDeviceToken"
            : packageInfo.buildNumber,
        //'va' : packageInfo.buildNumber,
        'vb': userid,
        'vc': password,
        'vd': 'user',
      };
      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE#${response.data}");
      return UserResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }
}
