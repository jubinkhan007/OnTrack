class DBConstant {
  static const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
  static const String textType = "TEXT NOT NULL";
  static const String textTypeWithNull = "TEXT";
  static const String intType = "INTEGER NOT NULL";
  static const String realType = "REAL NOT NULL";
  static const String realTypeWithNull = "REAL";
  static const String blobType = "BLOB";

  static const String tableStaff = "staff_table";
  static const String compId = "COMP_ID";
  static const String compName = "COMP_NAME";
  static const String userId = "USER_ID";
  static const String userName = "USER_NAME";
  static const String searchName = "SEARCH_NAME";
  static const String displayName = "DISPLAY_NAME";
  static const String staffId = "USER_HRIS";
  static const String userHris = "USER_HRIS";
  static const String designation = "DESIGNATION";

  static const String tableBU = "bu_table";
  static const String buId = "BU_ID";
  static const String id = "ID";
  static const String buName = "BU_NAME";

  static const String tablePendingTaskQueue = "pending_task_queue";
  static const String queueId = "ID";
  static const String queueCompanyId = "COMPANY_ID";
  static const String queueInquiryId = "INQUIRY_ID";
  static const String queueCustomerId = "CUSTOMER_ID";
  static const String queueCustomerName = "CUSTOMER_NAME";
  static const String queueIsSample = "IS_SAMPLE";
  static const String queueTitle = "TITLE";
  static const String queueDetails = "DETAILS";
  static const String queueDueDate = "DUE_DATE";
  static const String queueStartDate = "START_DATE";
  static const String queuePriorityId = "PRIORITY_ID";
  static const String queueUserId = "USER_ID";
  static const String queueAssignees = "ASSIGNEES";
  static const String queueCreatedAt = "CREATED_AT";
  static const String queueRetryCount = "RETRY_COUNT";

  static const String tablePendingTaskUpdateQueue = "pending_task_update_queue";
  static const String updateQueueId = "ID";
  static const String updateQueueInquiryId = "INQUIRY_ID";
  static const String updateQueueTaskId = "TASK_ID";
  static const String updateQueuePriorityId = "PRIORITY_ID";
  static const String updateQueueDescription = "DESCRIPTION";
  static const String updateQueueUserId = "USER_ID";
  static const String updateQueuePercentage = "PERCENTAGE";
  static const String updateQueueCreatedAt = "CREATED_AT";
  static const String updateQueueRetryCount = "RETRY_COUNT";
}
