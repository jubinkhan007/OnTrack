import '../db_helper.dart';

class StaffDAO {
  // Insert a list of staff into the database using batch insert
  Future<void> insertStaffList(List<Map<String, dynamic>> staffList) async {
    await DBHelper.instance.insertStaffList(staffList);
  }

  // Get all staff from the database
  Future<List<Map<String, dynamic>>> getStaffList() async {
    return await DBHelper.instance.getAllStaff();
  }

  // Optionally, you can delete all staff data
  Future<void> clearStaff() async {
    await DBHelper.instance.deleteAllStaff();
  }


}
