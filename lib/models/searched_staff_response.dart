class SearchedStaffResponse {
  List<SearchedStaff>? staffs;

  SearchedStaffResponse({this.staffs});

  SearchedStaffResponse.fromJson(Map<String, dynamic> json) {
    if (json['staffs'] != null) {
      staffs = <SearchedStaff>[];
      json['staffs'].forEach((v) {
        staffs!.add(SearchedStaff.fromJson(v));
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

class SearchedStaff {
  String? name;
  String? code;
  String? designation;
  String? department;
  String? companyName;
  String? mail;
  String? mobileNo;

  SearchedStaff.fromJson(Map<String, dynamic> json) {
    code = json['STAFFID'];
    name = json['STAFF_NAME'];
    designation =
        json['DESIGNATION']; // If already an int, no conversion needed
    department = json['DEPARTMENTNAME'];
    companyName = json['COMPANY_NAME'];
    mail = json['MAILID'];
    mobileNo = json['MOBILE_NO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['STAFFID'] = code;
    data['STAFF_NAME'] = name;
    data['DESIGNATION'] = designation;
    data['DEPARTMENTNAME'] = department;
    data['MAILID'] = mail;
    data['COMPANY_NAME'] = companyName;
    data['MOBILE_NO'] = mobileNo;
    return data;
  }
}
