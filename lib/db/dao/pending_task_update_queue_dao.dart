import 'package:sqflite/sqflite.dart';

import '../../models/new_task/pending_task_update_queue_item.dart';
import '../db_constant.dart';
import '../local_db.dart';

class PendingTaskUpdateQueueDao {
  final LocalDB localDB = LocalDB.instance;

  Future<int> enqueue(PendingTaskUpdateQueueItem item) async {
    final db = await localDB.db;
    return db.insert(
      DBConstant.tablePendingTaskUpdateQueue,
      item.toMap()..remove(DBConstant.updateQueueId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PendingTaskUpdateQueueItem>> getPendingUpdates() async {
    final db = await localDB.db;
    final rows = await db.query(
      DBConstant.tablePendingTaskUpdateQueue,
      orderBy: "${DBConstant.updateQueueId} ASC",
    );
    return rows.map(PendingTaskUpdateQueueItem.fromMap).toList();
  }

  Future<void> deleteById(int id) async {
    final db = await localDB.db;
    await db.delete(
      DBConstant.tablePendingTaskUpdateQueue,
      where: "${DBConstant.updateQueueId} = ?",
      whereArgs: [id],
    );
  }

  Future<void> incrementRetry(int id, int currentRetryCount) async {
    final db = await localDB.db;
    await db.update(
      DBConstant.tablePendingTaskUpdateQueue,
      {DBConstant.updateQueueRetryCount: currentRetryCount + 1},
      where: "${DBConstant.updateQueueId} = ?",
      whereArgs: [id],
    );
  }

  Future<void> remapInquiryId(String oldInquiryId, String newInquiryId) async {
    final db = await localDB.db;
    await db.update(
      DBConstant.tablePendingTaskUpdateQueue,
      {DBConstant.updateQueueInquiryId: newInquiryId},
      where: "${DBConstant.updateQueueInquiryId} = ?",
      whereArgs: [oldInquiryId],
    );
  }

  Future<void> remapTaskId(String oldTaskId, String newTaskId) async {
    final db = await localDB.db;
    await db.update(
      DBConstant.tablePendingTaskUpdateQueue,
      {DBConstant.updateQueueTaskId: newTaskId},
      where: "${DBConstant.updateQueueTaskId} = ?",
      whereArgs: [oldTaskId],
    );
  }
}
