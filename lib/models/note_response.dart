/*class NoteResponse {
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
}*/

class NoteResponse {
  List<Note>? notes;

  NoteResponse({this.notes});

  NoteResponse.fromJson(Map<String, dynamic> json) {
    if (json['notes'] != null) {
      notes = <Note>[];
      json['notes'].forEach((v) {
        notes!.add(Note.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notes != null) {
      data['notes'] = notes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Note {
  String? name;
  String? dateTime;
  String? description;
  String? status;

  Note({this.name, this.dateTime, this.description, this.status});

  Note.fromJson(Map<String, dynamic> json) {
    name = json['NAME'];
    dateTime = json['DATETIME'];
    description = json['COMMENTS'];
    status = json['STATUS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NAME'] = name;
    data['DATETIME'] = dateTime;
    data['COMMENTS'] = description;
    data['STATUS'] = status;
    return data;
  }
}
