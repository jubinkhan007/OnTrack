import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tmbi/models/models.dart';

import '../db_constant.dart';
import '../local_db.dart';

class StaffDao {
  final localDB = LocalDB.instance;

  Future<bool> isStaffTableEmpty() async {
    Database db = await localDB.db;
    var result =
        await db.rawQuery("SELECT COUNT(*) FROM ${DBConstant.tableStaff}");
    int count = Sqflite.firstIntValue(result)!;
    return count == 0;
  }

  Future<int> insertStaff(Staff staff) async {
    Database db = await localDB.db;
    var result = await db.insert(DBConstant.tableStaff, staff.toJson());
    return result;
  }

  Future<bool> insertStaffsFromJson1(List<Staff> reasons) async {
    try {
      Database db = await localDB.db;
      Batch batch = db.batch();
      for (var reason in reasons) {
        batch.insert(DBConstant.tableStaff, reason.toJson());
      }
      await batch.commit(noResult: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> insertStaffsFromJson(List<Staff> staffs) async {
    try {
      Database db = await localDB.db;
      // Start a transaction for atomicity
      await db.transaction((txn) async {
        // Step 1: Remove all existing records from the table
        await txn.delete(DBConstant.tableStaff); // This will delete all rows
        // Step 2: Create a batch and insert the new data
        Batch batch = txn.batch();
        for (var staff in staffs) {
          batch.insert(DBConstant.tableStaff, staff.toJson());
        }
        // Commit the batch operation
        await batch.commit(noResult: true);
      });

      return true;
    } catch (e) {
      debugPrint("Error inserting staff: $e");
      return false;
    }
  }

  Future<List<Staff>> getStaffs() async {
    Database db = await localDB.db;
    List<Map<String, dynamic>> maps = await db.query(DBConstant.tableStaff);

    List<Staff> staffs = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        staffs.add(Staff.fromJson(maps[i]));
      }
    }
    return staffs;
  }
}
