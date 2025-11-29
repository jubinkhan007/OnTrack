import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SignUpRepo {
  final Dio dio;

  SignUpRepo({required this.dio});

  Future<bool> signUp(
    String companyId,
    String inquiryId,
    String inquiryName,
    String inquiryDesc, // password
    String isSample,
    String neededDate,
    String priorityId,
    String customerId,
    String customerName, // full_name
    String userId, // email
    String tasks, // []
  ) async {
    try {
      final headers = {
        "dtype": "SIGN_UP",
        "compid": companyId,
        "custid": customerId,
        "inqrid": inquiryId,
        "inqrname": inquiryName,
        "inqrdesc": inquiryDesc,
        "salmpleflag": isSample,
        "needdate": neededDate,
        "userid": userId,
        "custname": customerName,
        "priorityid": priorityId,
        "taskdetail": tasks,
        "files": 0
      };

      final response = await dio.post(
        "saveall",
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE#${response.data}");
      return response.data['status'] == "200";
    } on DioException catch (error) {
      debugPrint("RESPONSE_ERROR#$error");
      throw Exception(error);
    }
  }
}
