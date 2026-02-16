import '../../db/db_constant.dart';

class PendingTaskUpdateQueueItem {
  final int? id;
  final String inquiryId;
  final String taskId;
  final String priorityId;
  final String description;
  final String userId;
  final String percentage;
  final String createdAt;
  final int retryCount;

  PendingTaskUpdateQueueItem({
    this.id,
    required this.inquiryId,
    required this.taskId,
    required this.priorityId,
    required this.description,
    required this.userId,
    required this.percentage,
    required this.createdAt,
    this.retryCount = 0,
  });

  factory PendingTaskUpdateQueueItem.fromMap(Map<String, dynamic> map) {
    return PendingTaskUpdateQueueItem(
      id: map[DBConstant.updateQueueId] as int?,
      inquiryId: (map[DBConstant.updateQueueInquiryId] ?? "").toString(),
      taskId: (map[DBConstant.updateQueueTaskId] ?? "").toString(),
      priorityId: (map[DBConstant.updateQueuePriorityId] ?? "").toString(),
      description: (map[DBConstant.updateQueueDescription] ?? "").toString(),
      userId: (map[DBConstant.updateQueueUserId] ?? "").toString(),
      percentage: (map[DBConstant.updateQueuePercentage] ?? "0").toString(),
      createdAt: (map[DBConstant.updateQueueCreatedAt] ?? "").toString(),
      retryCount: (map[DBConstant.updateQueueRetryCount] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DBConstant.updateQueueId: id,
      DBConstant.updateQueueInquiryId: inquiryId,
      DBConstant.updateQueueTaskId: taskId,
      DBConstant.updateQueuePriorityId: priorityId,
      DBConstant.updateQueueDescription: description,
      DBConstant.updateQueueUserId: userId,
      DBConstant.updateQueuePercentage: percentage,
      DBConstant.updateQueueCreatedAt: createdAt,
      DBConstant.updateQueueRetryCount: retryCount,
    };
  }
}
