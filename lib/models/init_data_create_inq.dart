class InitDataCreateInq {
  List<Company>? company;
  List<InquiryType>? inquiryType;
  List<Priority>? priority;

  InitDataCreateInq({this.company, this.inquiryType, this.priority});

  InitDataCreateInq.fromJson(Map<String, dynamic> json) {
    if (json['company'] != null) {
      company = <Company>[];
      json['company'].forEach((v) {
        company!.add(Company.fromJson(v));
      });
    }
    if (json['inquiry_type'] != null) {
      inquiryType = <InquiryType>[];
      json['inquiry_type'].forEach((v) {
        inquiryType!.add(InquiryType.fromJson(v));
      });
    }
    if (json['priority'] != null) {
      priority = <Priority>[];
      json['priority'].forEach((v) {
        priority!.add(Priority.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (company != null) {
      data['company'] = company!.map((v) => v.toJson()).toList();
    }
    if (inquiryType != null) {
      data['inquiry_type'] = inquiryType!.map((v) => v.toJson()).toList();
    }
    if (priority != null) {
      data['priority'] = priority!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Company {
  String? id;
  String? name;
  List<Customer>? customer;

  Company({this.name, this.customer});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['customer'] != null) {
      customer = <Customer>[];
      json['customer'].forEach((v) {
        customer!.add(Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (customer != null) {
      data['customer'] = customer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  String? id;
  String? name;
  String? isVerified;

  Customer({this.id, this.name, this.isVerified});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_verified'] = isVerified;
    return data;
  }
}

class InquiryType {
  String? id;
  String? name;

  InquiryType({this.id, this.name});

  InquiryType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Priority {
  String? id;
  String? name;

  Priority({this.id, this.name});

  Priority.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}