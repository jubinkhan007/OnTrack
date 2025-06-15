import 'dart:convert';

import 'package:tmbi/models/models.dart';

/*class InquiryResponse {
  final String id;
  final List<Task> tasks;
  final String title;
  final String status;
  final Comment comment;
  final String company;
  final Customer customer;
  final String endDate;
  final User postedBy;
  final Attachment attachment;
  final String description;

  InquiryResponse({
    required this.id,
    required this.tasks,
    required this.title,
    required this.status,
    required this.comment,
    required this.company,
    required this.customer,
    required this.endDate,
    required this.postedBy,
    required this.attachment,
    required this.description,
  });

  factory InquiryResponse.fromJson(Map<String, dynamic> json) {
    var tasksList = json['tasks'] as List;
    List<Task> taskList = tasksList.map((task) => Task.fromJson(task)).toList();

    return InquiryResponse(
      id: json['id'],
      tasks: taskList,
      title: json['title'],
      status: json['status'],
      comment: Comment.fromJson(json['comment']),
      company: json['company'],
      customer: Customer.fromJson(json['customer']),
      endDate: json['end_date'],
      postedBy: User.fromJson(json['posted_by']),
      attachment: Attachment.fromJson(json['attachment']),
      description: json['description'],
    );
  }
}

class Task {
  final String id;
  final String date;
  final String name;
  final bool hasAccess;
  final bool isUpdated;
  final String totalTime;
  final String assignedPerson;

  Task({
    required this.id,
    required this.date,
    required this.name,
    required this.hasAccess,
    required this.isUpdated,
    required this.totalTime,
    required this.assignedPerson,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      date: json['date'],
      name: json['name'],
      hasAccess: json['has_access'],
      isUpdated: json['is_updated'],
      totalTime: json['total_time'],
      assignedPerson: json['assigned_person'],
    );
  }
}

class Comment {
  final String id;
  final String count;

  Comment({required this.id, required this.count});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      count: json['count'],  // count is returned as a String in the JSON
    );
  }
}

class Attachment {
  final String id;
  final String count;

  Attachment({required this.id, required this.count});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      count: json['count'],  // count is returned as a String in the JSON
    );
  }
}

class User {
  final String id;
  final String name;
  final bool isOwner;

  User({
    required this.id,
    required this.name,
    required this.isOwner,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      isOwner: json['is_owner'],
    );
  }
}*/

class InquiryResponse {
  //final String id;
  final int id;
  final List<Task> tasks;
  //final String title;
   String title;

  //final String status;
  final Comment comment;
  final String? company;
  final Customer customer;
  //final String endDate;
   String endDate;
  final User postedBy;
  final Attachment attachment;
   String description;

  InquiryResponse({
    required this.id,
    required this.tasks,
    required this.title,
    //required this.status,
    required this.comment,
    required this.company,
    required this.customer,
    required this.endDate,
    required this.postedBy,
    required this.attachment,
    required this.description,
  });

  factory InquiryResponse.fromJson(Map<String, dynamic> json) {
    //var tasksList = json['TASKS'] as List;
    var tasksList = json['TASKS'] != null ? json['TASKS'] as List : <dynamic>[];
    List<Task> taskList = tasksList.map((task) => Task.fromJson(task)).toList();

    return InquiryResponse(
      id: json['ID'],
      tasks: taskList,
      title: json['TITLE'].toString(),
      //status: json['STATUS'],
      //comment: Comment.fromJson(json['COMMENT']),
      company: json['COMPANY'],
      endDate: json['END_DATE'],
      /*customer: Customer.fromJson(json['CUSTOMER']),
      postedBy: User.fromJson(json['POSTED_BY']),
      attachment: Attachment.fromJson(json['ATTACHMENT']),*/
      postedBy: User.fromJson(jsonDecode(json['POSTED_BY'])),
      // Decode JSON string to Map
      attachment: Attachment.fromJson(jsonDecode(json['ATTACHMENT'])),
      // Decode JSON string to Map
      customer: Customer.fromJson(jsonDecode(json['CUSTOMER'])),
      // Decode JSON string to Map
      comment: Comment.fromJson(jsonDecode(json['COMMENTS'])),
      // Decode JSON string to Map
      description: json['DESCRIPTION'].toString(),
    );
  }
}

class Task {
  //final String id;
  final int id;
  //final String date;
  String date;
  //final String name;
  String name;
  /*final*/ bool hasAccess;

  //final String totalTime;
  final int totalTime;

  //final bool isUpdated;
  bool isUpdated;

  //final String status;
  String status;
  //final String assignedPerson;
  String assignedPerson;

  double totalPercentage;

  bool isCopy;

  Task({
    required this.id,
    required this.date,
    required this.name,
    required this.hasAccess,
    required this.isUpdated,
    required this.totalTime,
    required this.status,
    required this.assignedPerson,

    this.totalPercentage = 0,

    this.isCopy = false
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['TASK_ID'],
      date: json['DATETIME'],
      name: json['TASK_NAME'].toString(),
      hasAccess: json['HAS_ACCESS'],
      isUpdated: json['IS_UPDATED'],
      totalTime: json['TOTAL_TIME'],
      status: json['STATUS'],
      assignedPerson: json['ASSIGNED_PERSON'],

      totalPercentage: json['TOTAL_PERCENTAGE'] != null
          ? double.tryParse(json['TOTAL_PERCENTAGE'].toString()) ?? 0
          : 0,
    );
  }

  // TEST
  // CopyWith method to create a copy of the Task with some modified fields
  Task copyWith({
    int? id,
    String? date,
    String? name,
    bool? hasAccess,
    int? totalTime,
    bool? isUpdated,
    String? status,
    String? assignedPerson,

    double? totalPercentage,

    bool? isCopy
  }) {
    return Task(
      id: id ?? this.id,  // Use the current value if null is passed
      date: date ?? this.date,
      name: name ?? this.name,
      hasAccess: hasAccess ?? this.hasAccess,
      totalTime: totalTime ?? this.totalTime,
      isUpdated: isUpdated ?? this.isUpdated,
      status: status ?? this.status,
      assignedPerson: assignedPerson ?? this.assignedPerson,

      totalPercentage: totalPercentage ?? this.totalPercentage,

      isCopy: true,
    );
  }
}

class Comment {
  final String id;
  final String? count;

  Comment({required this.id, required this.count});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      count: json['count'] ?? "0", // count is returned as a String in the JSON
    );
  }
}

class Attachment {
  final String id;
  final String? count;

  Attachment({required this.id, required this.count});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      //count: json['count'] ?? "0", // count is returned as a String in the JSON
      count: json['count'] as String? ?? "0",
    );
  }
}

class User {
  final String id;
  final String staffId;
  final String name;
  final bool isOwner;

  User({
    required this.id,
    required this.staffId,
    required this.name,
    required this.isOwner,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      staffId: json['staff'],
      name: json['name'],
      isOwner: json['is_owner'] == 'true',
    );
  }
}

class Todo {
  final String title;
  final String date;
  final bool isChecked;
  final List<User> assigns;

  Todo(
      {required this.title,
      required this.date,
      required this.isChecked,
      required this.assigns});

  factory Todo.fromJson(Map<String, dynamic> json) {
    var usersList = (json['assigns'] as List)
        .map((userJson) => User.fromJson(userJson))
        .toList();

    return Todo(
      title: json['title'],
      date: json['date'],
      isChecked: json['isChecked'] == 'true',
      assigns: usersList,
    );
  }
}
