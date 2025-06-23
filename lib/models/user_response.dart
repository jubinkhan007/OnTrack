class UserResponse {
  List<User>? users;
  Status? status;

  UserResponse({this.users, this.status});

  UserResponse.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      users = <User>[];
      json['user'].forEach((v) {
        users!.add(User.fromJson(v));
      });
    }
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (users != null) {
      data['user'] = users!.map((v) => v.toJson()).toList();
    }
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class User {
  String? staffName;
  String? staffId;
  //String password = "";
  String? password;
  String? designation;
  String? mailId;
  String? mobileNo;

  User({this.staffName, this.designation, this.mailId/*, this.password = ""*/});

  User.fromJson(Map<String, dynamic> json) {
    staffName = json['STAFF_NAME'];
    staffId = json['STAFFID'];
    designation = json['DESIGNATION'];
    mailId = json['MAILID'];

    password = json['PASSWORD'] ?? "";
    mobileNo = json['MOBILE_NO'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['STAFF_NAME'] = staffName;
    data['STAFFID'] = staffId;
    data['DESIGNATION'] = designation;
    data['MAILID'] = mailId;

    data['PASSWORD'] = password;
    data['MOBILE_NO'] = mobileNo;

    return data;
  }
}

class Status {
  int? code;
  String? message;

  Status({this.code, this.message});

  Status.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}

