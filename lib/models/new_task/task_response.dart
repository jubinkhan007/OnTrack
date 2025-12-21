class TaskDataModel {
  List<TaskResponse> data;

  TaskDataModel({required this.data});

  factory TaskDataModel.fromJson(Map<String, dynamic> json) {
    var list = json['Data'] as List;
    List<TaskResponse> dataList =
        list.map((i) => TaskResponse.fromJson(i)).toList();

    return TaskDataModel(
      data: dataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Data': data.map((taskStatus) => taskStatus.toJson()).toList(),
    };
  }
}

/*class TaskResponse {
  String pending;
  String overdue;
  String completed;
  List<Task> tasks;

  TaskResponse({
    required this.pending,
    required this.overdue,
    required this.completed,
    required this.tasks,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    var list = json['TASKS'] as List;
    List<Task> taskList = list.map((i) => Task.fromJson(i)).toList();

    return TaskResponse(
      pending: json['PENNDING'].toString(),
      overdue: json['OVERDUE'].toString(),
      completed: json['COMPLETED'].toString(),
      tasks: taskList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PENNDING': pending,
      'OVERDUE': overdue,
      'COMPLETED': completed,
      'TASKS': tasks.map((task) => task.toJson()).toList(),
    };
  }
}*/

class TaskResponse {
  String pending;
  String overdue;
  String completed;
  List<Task> tasks;

  TaskResponse({
    required this.pending,
    required this.overdue,
    required this.completed,
    required this.tasks,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    // Handle null for 'TASKS' and convert to an empty list if null
    var list = json['TASKS'] as List? ?? []; // if 'TASKS' is null, use an empty list
    List<Task> taskList = list.map((i) => Task.fromJson(i)).toList();

    return TaskResponse(
      pending: json['PENNDING'].toString(),
      overdue: json['OVERDUE'].toString(),
      completed: json['COMPLETED'].toString(),
      tasks: taskList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PENNDING': pending,
      'OVERDUE': overdue,
      'COMPLETED': completed,
      'TASKS': tasks.map((task) => task.toJson()).toList(),
    };
  }
}

class Task {
  String tnstHris;
  String id;
  String name;
  String assignToId;
  String assignToName;
  String completion;
  String createdDate;
  String status;
  String commentCount;

  Task({
    required this.tnstHris,
    required this.id,
    required this.name,
    required this.assignToId,
    required this.assignToName,
    required this.completion,
    required this.createdDate,
    required this.status,
    this.commentCount = "0",
  });

  // Factory method to parse JSON into Task
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      tnstHris: json['TNST_HRIS'].toString(),
      id: json['ID'].toString(),
      name: json['NAME'].toString(),
      assignToId: json['ASSIGN_TO_ID'].toString(),
      assignToName: json['ASSIGN_TO_NAME'].toString(),
      completion: json['COMPLETION'].toString(),
      createdDate: json['CREATED_DATE'].toString(),
      status: json['STATUS'].toString(),
      commentCount: json['COMMENT_COUNT'] != null ? json['COMMENT_COUNT'].toString() : '0',
    );
  }

  // Method to convert Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'TNST_HRIS': tnstHris,
      'ID': id,
      'NAME': name,
      'ASSIGN_TO_ID': assignToId,
      'ASSIGN_TO_NAME': assignToName,
      'COMPLETION': completion,
      'CREATED_DATE': createdDate,
      'STATUS': status,
      'COMMENT_COUNT': commentCount,
    };
  }
}
