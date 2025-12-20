class CommentResponse {
  List<Comment>? comments;

  CommentResponse({this.comments});

  CommentResponse.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = <Comment>[];
      json['comments'].forEach((v) {
        comments!.add(Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comment {
  String? name;
  String? staffId;
  String? dateTime;
  String? body;

  Comment({this.name, this.staffId, this.dateTime, this.body});

  Comment.fromJson(Map<String, dynamic> json) {
    name = json['NAME'];
    staffId = json['STAFFID'];
    dateTime = json['DATETIME'];
    body = json['COMMENTS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NAME'] = name;
    data['STAFFID'] = staffId;
    data['DATETIME'] = dateTime;
    data['COMMENTS'] = body;
    return data;
  }
}
