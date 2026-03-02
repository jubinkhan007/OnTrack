import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tmbi/network/http_header_sanitizer.dart';

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
      final safeInquiryName = HttpHeaderSanitizer.sanitize(inquiryName);
      final safeInquiryDesc = HttpHeaderSanitizer.sanitize(inquiryDesc);
      final safeCustomerName = HttpHeaderSanitizer.sanitize(customerName);
      final safeUserId = HttpHeaderSanitizer.sanitize(userId);
      final safeTasks = HttpHeaderSanitizer.sanitize(tasks);

      final headers = {
        "dtype": "SIGN_UP",
        "compid": companyId,
        "custid": customerId,
        "inqrid": inquiryId,
        "inqrname": safeInquiryName,
        "inqrdesc": safeInquiryDesc,
        // Backwards/forwards compatibility: some backends use a misspelled key.
        "salmpleflag": isSample,
        "sampleflag": isSample,
        "needdate": neededDate,
        "userid": safeUserId,
        "custname": safeCustomerName,
        "priorityid": priorityId,
        "taskdetail": safeTasks,
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
