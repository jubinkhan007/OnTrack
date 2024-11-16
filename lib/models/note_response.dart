class NoteResponse {
  String? taskId;
  List<Notes>? notes;

  NoteResponse({this.taskId, this.notes});

  NoteResponse.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    if (json['notes'] != null) {
      notes = <Notes>[];
      json['notes'].forEach((v) {
        notes!.add(Notes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['task_id'] = taskId;
    if (notes != null) {
      data['notes'] = notes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notes {
  String? id;
  String? desc;
  String? date;
  String? time;

  Notes({this.id, this.desc, this.date, this.time});

  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    desc = json['desc'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['desc'] = desc;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}
