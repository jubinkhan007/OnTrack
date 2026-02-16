import '../../db/db_constant.dart';

class PendingTaskQueueItem {
  final int? id;
  final String companyId;
  final String inquiryId;
  final String customerId;
  final String customerName;
  final String isSample;
  final String title;
  final String details;
  final String dueDate;
  final String startDate;
  final String priorityId;
  final String userId;
  final String assignees;
  final String createdAt;
  final int retryCount;

  PendingTaskQueueItem({
    this.id,
    required this.companyId,
    required this.inquiryId,
    required this.customerId,
    required this.customerName,
    required this.isSample,
    required this.title,
    required this.details,
    required this.dueDate,
    required this.startDate,
    required this.priorityId,
    required this.userId,
    required this.assignees,
    required this.createdAt,
    this.retryCount = 0,
  });

  factory PendingTaskQueueItem.fromMap(Map<String, dynamic> map) {
    return PendingTaskQueueItem(
      id: map[DBConstant.queueId] as int?,
      companyId: (map[DBConstant.queueCompanyId] ?? "0").toString(),
      inquiryId: (map[DBConstant.queueInquiryId] ?? "0").toString(),
      customerId: (map[DBConstant.queueCustomerId] ?? "0").toString(),
      customerName: (map[DBConstant.queueCustomerName] ?? "Other").toString(),
      isSample: (map[DBConstant.queueIsSample] ?? "N").toString(),
      title: (map[DBConstant.queueTitle] ?? "").toString(),
      details: (map[DBConstant.queueDetails] ?? "-").toString(),
      dueDate: (map[DBConstant.queueDueDate] ?? "").toString(),
      startDate: (map[DBConstant.queueStartDate] ?? "").toString(),
      priorityId: (map[DBConstant.queuePriorityId] ?? "1").toString(),
      userId: (map[DBConstant.queueUserId] ?? "").toString(),
      assignees: (map[DBConstant.queueAssignees] ?? "[]").toString(),
      createdAt: (map[DBConstant.queueCreatedAt] ?? "").toString(),
      retryCount: (map[DBConstant.queueRetryCount] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DBConstant.queueId: id,
      DBConstant.queueCompanyId: companyId,
      DBConstant.queueInquiryId: inquiryId,
      DBConstant.queueCustomerId: customerId,
      DBConstant.queueCustomerName: customerName,
      DBConstant.queueIsSample: isSample,
      DBConstant.queueTitle: title,
      DBConstant.queueDetails: details,
      DBConstant.queueDueDate: dueDate,
      DBConstant.queueStartDate: startDate,
      DBConstant.queuePriorityId: priorityId,
      DBConstant.queueUserId: userId,
      DBConstant.queueAssignees: assignees,
      DBConstant.queueCreatedAt: createdAt,
      DBConstant.queueRetryCount: retryCount,
    };
  }
}
