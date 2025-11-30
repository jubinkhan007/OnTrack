import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tmbi/models/new_task/bu_response.dart';

class SyncRepo {
  final Dio dio;

  SyncRepo({required this.dio});

  Future<BuResponse> getStuffs(String staffId) async {
    try {
      final headers = {
        'vm': 'BUALL',
        'va': '0',
        'vb': staffId,
        'vc': '0',
        'vd': 'BU',
      };
      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE#${response.data}");
      return BuResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

}