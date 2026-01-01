class MainTaskResponse {
  List<MainTask> data;

  MainTaskResponse({required this.data});

  factory MainTaskResponse.fromJson(Map<String, dynamic> json) {
    // Null safe list parsing
    var list = json['DATA'] as List? ?? [];

    return MainTaskResponse(
      data: list.map((item) => MainTask.fromJson(item ?? {})).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DATA': data.map((e) => e.toJson()).toList(),
    };
  }
}

class MainTask {
  String mainTaskId;
  String mainTaskName;
  String mainTaskDetail;
  String totalCompletion;
  String date;
  String status;
  List<SubTask> tasks;

  MainTask({
    required this.mainTaskId,
    required this.mainTaskName,
    this.mainTaskDetail = "-",
    required this.totalCompletion,
    required this.date,
    required this.status,
    required this.tasks,
  });

  factory MainTask.fromJson(Map<String, dynamic> json) {
    // tasks list null check
    var list = json['TASKS'] as List? ?? [];

    return MainTask(
      mainTaskId: json['MAIN_TASK_ID'].toString(),
      mainTaskName: json['MAIN_TASK_NAME'].toString(),
      mainTaskDetail: json['MAIN_TASK_DETAIL'].toString(),
      totalCompletion: json['TOTAL_COMPLETION'].toString(),
      date: json['ENTRY_DATE'].toString(),
      status: json['STATUS'].toString(),
      tasks: list.map((e) => SubTask.fromJson(e ?? {})).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MAIN_TASK_ID': mainTaskId,
      'MAIN_TASK_NAME': mainTaskName,
      'MAIN_TASK_DETAIL': mainTaskDetail,
      'TOTAL_COMPLETION': totalCompletion,
      'ENTRY_DATE': date,
      'STATUS': status,
      'TASKS': tasks.map((e) => e.toJson()).toList(),
    };
  }
}

class SubTask {
  String id;
  String name;
  String assignToId;
  String assignToName;
  String completion;
  String date;
  String status;
  String lastComment;
  String commentCount;

  SubTask({
    required this.id,
    required this.name,
    required this.assignToId,
    required this.assignToName,
    required this.completion,
    required this.date,
    required this.status,
    required this.lastComment,
    this.commentCount = "0",
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['TASK_ID'].toString(),
      name: json['TASK_NAME'].toString(),
      assignToId: json['ASSIGN_TO_ID'].toString(),
      assignToName: json['ASSIGN_TO_NAME'].toString(),
      completion: json['COMPLETION'].toString(),
      date: json['TASK_DATE'].toString(),
      status: json['STATUS'].toString(),
      lastComment: json['LAST_COMMENTS'].toString(),
      commentCount: json['COMMENT_COUNT'] != null
          ? json['COMMENT_COUNT'].toString()
          : '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TASK_ID': id,
      'TASK_NAME': name,
      'ASSIGN_TO_ID': assignToId,
      'ASSIGN_TO_NAME': assignToName,
      'COMPLETION': completion,
      'TASK_DATE': date,
      'STATUS': status,
      'LAST_COMMENTS': lastComment,
      'COMMENT_COUNT': commentCount,
    };
  }
}
