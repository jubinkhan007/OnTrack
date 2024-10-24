class UserResponse {
  List<User> users;

  UserResponse({required this.users});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    var userList = json['user'] as List;
    List<User> users = userList.map((i) => User.fromJson(i)).toList();

    return UserResponse(users: users);
  }

  Map<String, dynamic> toJson() {
    return {
      'user': users.map((user) => user.toJson()).toList(),
    };
  }
}

class User {
  String staffName;
  String designation;
  String mailId;

  User({
    required this.staffName,
    required this.designation,
    required this.mailId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      staffName: json['STAFF_NAME'],
      designation: json['DESIGNATION'],
      mailId: json['MAILID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'STAFF_NAME': staffName,
      'DESIGNATION': designation,
      'MAILID': mailId,
    };
  }
}
