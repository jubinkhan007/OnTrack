import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../db/dao/staff_dao2.dart';

class DataSyncRepo {
  //final Dio dio;

  DataSyncRepo(/*{required this.dio}*/);

  Future<Map<String, dynamic>> getStaffs(String staffId) async {
    try {
      final headers = {
        'vm': 'COMP',
        'va': '5',
        'vb': staffId,
        'vc': '123456',
        'vd': 'company',
      };

      final response = await Dio().get(
        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/getall",  // Replace with actual API endpoint
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE# ${response.data}");
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    }
  }


  Future<void> getStaffs2(String staffId) async {
    try {
      final headers = {
        'vm': 'COMP',
        'va': '5',
        'vb': staffId,
        'vc': '123456',
        'vd': 'company',
      };

      final response = await Dio().get(
        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/getall/getall",  // Replace with actual API endpoint
        options: Options(headers: headers),
      );

      debugPrint("RESPONSE# ${response.data}");

      // Assuming the response is a list of staff records
      List<Map<String, dynamic>> staffList = [];
      for (var staff in response.data) {
        staffList.add({
          'compId': staff['COMP_ID'],
          'userId': staff['USER_ID'],
          'userHris': staff['USER_HRIS'],
          'userName': staff['USER_NAME'],
          'searchName': staff['SEARCH_NAME'],
          'displayName': staff['DISPLAY_NAME'],
        });
      }

      // Store the staff data in the local database using batch insert
      StaffDAO staffDAO = StaffDAO();
      await staffDAO.insertStaffList(staffList);

      // Optionally, print the staff data stored in the DB
      List<Map<String, dynamic>> storedStaff = await staffDAO.getStaffList();
      debugPrint("Stored Staff: $storedStaff");

    } on DioException catch (error) {
      throw Exception(error);
    }
  }


}