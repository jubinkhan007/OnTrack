class StaffResponse {
  List<Staff>? staffs;

  StaffResponse({this.staffs});

  StaffResponse.fromJson(Map<String, dynamic> json) {
    if (json['staffs'] != null) {
      staffs = <Staff>[];
      json['staffs'].forEach((v) {
        staffs!.add(Staff.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (staffs != null) {
      data['staffs'] = staffs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Staff {
  String? name;
  String? code;
  int? id;
  String? designation;

  Staff({this.name, this.code, this.id, this.designation});

  Staff.fromJson(Map<String, dynamic> json) {
    name = json['USER_NAME'];
    code = json['USER_HRIS'];
    //id = json['USER_ID'];
    id = json['USER_ID'] is String
        ? int.tryParse(json['USER_ID'])
        : json['USER_ID'];  // If already an int, no conversion needed
    designation = json['DESIGNATION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USER_NAME'] = name;
    data['USER_HRIS'] = code;
    data['USER_ID'] = id;
    data['DESIGNATION'] = designation;
    return data;
  }
}