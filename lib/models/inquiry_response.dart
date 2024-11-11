/*import 'dart:convert';

class InquiryResponse {
  final String id;
  final String title;
  final String description;
  final String company;
  final String endDate;
  final String status;
  final int commentCount;
  final int attachmentCount;
  final User postedBy;
  final Buyer buyerInfo;
  final List<Task> tasks;

  InquiryResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.endDate,
    required this.status,
    required this.commentCount,
    required this.attachmentCount,
    required this.postedBy,
    required this.buyerInfo,
    required this.tasks,
  });

  factory InquiryResponse.fromJson(Map<String, dynamic> json) {
    var tasksList = json['tasks'] as List;
    List<Task> taskList = tasksList.map((task) => Task.fromJson(task)).toList();

    return InquiryResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      company: json['company'],
      endDate: json['end_date'],
      status: json['status'],
      commentCount: int.parse(json['comment_count']),
      attachmentCount: int.parse(json['attachemnt_count']),
      postedBy: User.fromJson(json['posted_by']),
      buyerInfo: Buyer.fromJson(json['buyer_info']),
      tasks: taskList,
    );
  }
}

class User {
  final String id;
  final String name;
  final bool isOwner;

  User({required this.id, required this.name, required this.isOwner});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      isOwner: json['is_owner'],
    );
  }
}

class Buyer {
  final String id;
  final String name;
  final bool isVerified;

  Buyer({required this.id, required this.name, required this.isVerified});

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'],
      name: json['name'],
      isVerified: json['is_verified'],
    );
  }
}

class Task {
  final String id;
  final String name;
  final String date;
  final String totalTime;
  final bool hasAccess;
  final bool isUpdated;
  final String assignedPerson;

  Task({
    required this.id,
    required this.name,
    required this.date,
    required this.totalTime,
    required this.hasAccess,
    required this.isUpdated,
    required this.assignedPerson,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      totalTime: json['total_time'],
      hasAccess: json['has_access'],
      isUpdated: json['is_updated'],
      assignedPerson: json['assigned_person'],
    );
  }
}*/

import 'package:tmbi/models/models.dart';

/*class InquiryResponse {
  final String id;
  final String title;
  final String description;
  final String company;
  final String endDate;
  final String status;
  //final String commentCount;
  //final String attachmentCount;
  final Comment comment; // Change to Comment type
  final Attachment attachment; // Change to Attachment type
  final User postedBy;
  final Customer customer;
  final List<Task> tasks;

  InquiryResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.endDate,
    required this.status,
    //required this.commentCount,
    //required this.attachmentCount,
    required this.comment,
    required this.attachment,
    required this.postedBy,
    required this.customer,
    required this.tasks,
  });

  factory InquiryResponse.fromJson(Map<String, dynamic> json) {
    var tasksList = json['tasks'] as List;
    List<Task> taskList = tasksList.map((task) => Task.fromJson(task)).toList();

    return InquiryResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      company: json['company'],
      endDate: json['end_date'],
      status: json['status'],
      //commentCount: json['comment']['count'],
      //attachmentCount: json['attachment']['count'],
      comment: Comment.fromJson(json['comment']),
      attachment: Attachment.fromJson(json['attachment']),
      postedBy: User.fromJson(json['posted_by']),
      customer: Customer.fromJson(json['customer']),
      tasks: taskList,
    );
  }
}

class User {
  final String id;
  final String name;
  final bool isOwner;

  User({required this.id, required this.name, required this.isOwner});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      isOwner: json['is_owner'],
    );
  }
}

class Task {
  final String id;
  final String name;
  final String date;
  final String totalTime;
  final bool hasAccess;
  final bool isUpdated;
  final String assignedPerson;

  Task({
    required this.id,
    required this.name,
    required this.date,
    required this.totalTime,
    required this.hasAccess,
    required this.isUpdated,
    required this.assignedPerson,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      totalTime: json['total_time'],
      hasAccess: json['has_access'],
      isUpdated: json['is_updated'],
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
      count: json['count'],
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
      count: json['count'],
    );
  }
}*/

class InquiryResponse {
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
}



