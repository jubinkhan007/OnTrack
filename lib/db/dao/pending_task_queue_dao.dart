import 'package:sqflite/sqflite.dart';

import '../../models/new_task/pending_task_queue_item.dart';
import '../db_constant.dart';
import '../local_db.dart';

class PendingTaskQueueDao {
  final LocalDB localDB = LocalDB.instance;

  Future<int> enqueue(PendingTaskQueueItem item) async {
    final db = await localDB.db;
    return db.insert(
      DBConstant.tablePendingTaskQueue,
      item.toMap()..remove(DBConstant.queueId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PendingTaskQueueItem>> getPendingTasks() async {
    final db = await localDB.db;
    final rows = await db.query(
      DBConstant.tablePendingTaskQueue,
      orderBy: "${DBConstant.queueId} ASC",
    );
    return rows.map(PendingTaskQueueItem.fromMap).toList();
  }

  Future<int> pendingCount() async {
    final db = await localDB.db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DBConstant.tablePendingTaskQueue}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> deleteById(int id) async {
    final db = await localDB.db;
    await db.delete(
      DBConstant.tablePendingTaskQueue,
      where: "${DBConstant.queueId} = ?",
      whereArgs: [id],
    );
  }

  Future<void> incrementRetry(int id, int currentRetryCount) async {
    final db = await localDB.db;
    await db.update(
      DBConstant.tablePendingTaskQueue,
      {DBConstant.queueRetryCount: currentRetryCount + 1},
      where: "${DBConstant.queueId} = ?",
      whereArgs: [id],
    );
  }
}
