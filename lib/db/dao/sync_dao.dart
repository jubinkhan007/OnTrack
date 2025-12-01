
import 'package:sqflite/sqflite.dart';

import '../../models/new_task/bu_response.dart';
import '../db_constant.dart';
import '../local_db.dart';

class SyncDao {
  final localDB = LocalDB.instance;

  Future<void> deleteTable(String tableName) async {
    Database db = await localDB.db;
    await db.delete(tableName);
  }

  Future<void> insertStaffsBatch(
      List<BusinessUnit> list, void Function(double) onProgress) async {
    final db = await localDB.db;
    const batchSize = 200;
    final total = list.length;

    for (int i = 0; i < total; i += batchSize) {
      final end = (i + batchSize > total) ? total : i + batchSize;
      final batchList = list.sublist(i, end);

      await db.transaction((txn) async {
        final batch = txn.batch();
        for (var bu in batchList) {
          batch.insert(
            DBConstant.tableStaff,
            bu.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await batch.commit(noResult: true);
      });

      // Call progress callback
      onProgress(end / total * 100);

      // Small delay to keep UI responsive
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<bool> isTableExist(String tableName) async {
    final db = await localDB.db;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  Future<bool> isTableEmpty(String tableName) async {
    final db = await localDB.db;
    var result = await db.query(tableName, limit: 1);
    return result.isEmpty;
  }

  Future<List<BusinessUnit>> getAllStaffs() async {
    final db = await localDB.db;
    final List<Map<String, dynamic>> maps =
    await db.query(DBConstant.tableStaff);

    // Convert each map to a BusinessUnit object
    return List.generate(maps.length, (i) {
      return BusinessUnit.fromJson(maps[i]);
    });
  }

}
