class NotificationResponse {
  final List<Notification> data;

  NotificationResponse({required this.data});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      data:
          (json["Data"] as List).map((e) => Notification.fromJson(e)).toList(),
    );
  }
}

class Notification {
  final String notifInqm;
  final String notifTaskId;
  final String notifId;
  final String notifTitle;
  final String notifBody;
  final String notifType;
  final String assignName;
  final String assignId;
  final String time;
  final String date;

  Notification({
    required this.notifInqm,
    required this.notifTaskId,
    required this.notifId,
    required this.notifTitle,
    required this.notifBody,
    required this.notifType,
    required this.assignName,
    required this.assignId,
    required this.time,
    required this.date,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notifInqm: json["NOTIF_INQM"].toString(),
      notifTaskId: json["NOTIF_TASKID"].toString() ,
      notifId: json["NOTIF_ID"].toString() ,
      notifTitle: json["NOTIF_TITLE"].toString() ,
      notifBody: json["NOTIF_BODY"].toString() ,
      notifType: json["NOTIF_TYPE"].toString() ,
      assignName: json["ASSIGNER_NAME"].toString() ,
      assignId: json["ASSIGNER_ID"].toString() ,
      time: json["NOTIF_TIME"].toString() ,
      date: json["NOTIF_DATE"].toString() ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "NOTIF_INQM": notifInqm,
      "NOTIF_TASKID": notifTaskId,
      "NOTIF_ID": notifId,
      "NOTIF_TITLE": notifTitle,
      "NOTIF_BODY": notifBody,
      "NOTIF_TYPE": notifType,
      "ASSIGN_NAME": assignName,
      "ASSIGN_ID": assignId,
      "NOTIF_TIME": time,
      "NOTIF_DATE": date,
    };
  }
}
