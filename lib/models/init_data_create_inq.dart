/*
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
}*/
/*class InitDataCreateInq {
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
    if (json['inquery'] != null) { // Fixed the key from 'inquiry_type' to 'inquery'
      inquiryType = <InquiryType>[];
      json['inquery'].forEach((v) {
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
      data['inquery'] = inquiryType!.map((v) => v.toJson()).toList(); // Fixed key to 'inquery'
    }
    if (priority != null) {
      data['priority'] = priority!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Company {
  int? id; // Changed type to int
  String? name;
  List<Customer>? customer;

  Company({this.id, this.name, this.customer});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['ID']; // Fixed key to match JSON
    name = json['NAME']; // Fixed key to match JSON
    if (json['CUSTOMER'] != null) { // Fixed key to match JSON
      customer = <Customer>[];
      json['CUSTOMER'].forEach((v) {
        customer!.add(Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id; // Fixed key to match JSON
    data['NAME'] = name; // Fixed key to match JSON
    if (customer != null) {
      data['CUSTOMER'] = customer!.map((v) => v.toJson()).toList(); // Fixed key to match JSON
    }
    return data;
  }
}

class Customer {
  String? id; // Changed type to int
  String? name;
  bool? isVerified; // Changed type to bool

  Customer({this.id, this.name, this.isVerified});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['ID']; // Fixed key to match JSON
    name = json['NAME']; // Fixed key to match JSON
    isVerified = json['IS_VERIFIED']; // Fixed key to match JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id; // Fixed key to match JSON
    data['NAME'] = name; // Fixed key to match JSON
    data['IS_VERIFIED'] = isVerified; // Fixed key to match JSON
    return data;
  }
}

class InquiryType {
  int? id; // Changed type to int
  String? name;

  InquiryType({this.id, this.name});

  InquiryType.fromJson(Map<String, dynamic> json) {
    id = json['INQR_ID']; // Fixed key to match JSON
    name = json['INQR_TYPE']; // Fixed key to match JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['INQR_ID'] = id; // Fixed key to match JSON
    data['INQR_TYPE'] = name; // Fixed key to match JSON
    return data;
  }
}

class Priority {
  int? id; // Changed type to int
  String? name;

  Priority({this.id, this.name});

  Priority.fromJson(Map<String, dynamic> json) {
    id = json['ID']; // Fixed key to match JSON
    name = json['NAME']; // Fixed key to match JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id; // Fixed key to match JSON
    data['NAME'] = name; // Fixed key to match JSON
    return data;
  }
}*/
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
    if (json['inquery'] != null) {
      inquiryType = <InquiryType>[];
      json['inquery'].forEach((v) {
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
      data['inquery'] = inquiryType!.map((v) => v.toJson()).toList();
    }
    if (priority != null) {
      data['priority'] = priority!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Company {
  int? id; // Changed to int
  String? name;
  List<Customer>? customer;

  Company({this.id, this.name, this.customer});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['ID']; // Ensure this is an integer in JSON
    name = json['NAME'];
    if (json['CUSTOMER'] != null) {
      customer = <Customer>[];
      json['CUSTOMER'].forEach((v) {
        customer!.add(Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['NAME'] = name;
    if (customer != null) {
      data['CUSTOMER'] = customer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  int? id; // Changed to int
  String? name;
  bool? isVerified;

  Customer({this.id, this.name, this.isVerified});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['ID']; // Ensure this is an integer in JSON
    name = json['NAME'];
    isVerified = json['IS_VERIFIED'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['NAME'] = name;
    data['IS_VERIFIED'] = isVerified;
    return data;
  }
}

class InquiryType {
  int? id; // Changed to int
  String? name;

  InquiryType({this.id, this.name});

  InquiryType.fromJson(Map<String, dynamic> json) {
    id = json['INQR_ID']; // Ensure this is an integer in JSON
    name = json['INQR_TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['INQR_ID'] = id;
    data['INQR_TYPE'] = name;
    return data;
  }
}

class Priority {
  int? id; // Changed to int
  String? name;

  Priority({this.id, this.name});

  Priority.fromJson(Map<String, dynamic> json) {
    id = json['ID']; // Ensure this is an integer in JSON
    name = json['NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['NAME'] = name;
    return data;
  }
}


