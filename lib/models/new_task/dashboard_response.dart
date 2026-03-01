class DeptWiseStatus {
  final String deptName;
  final String total;
  final String last30Days;
  final String onHand;
  final String overdue;
  final String successPercent;
  final String delay;

  DeptWiseStatus({
    required this.deptName,
    required this.total,
    required this.last30Days,
    required this.onHand,
    required this.overdue,
    required this.successPercent,
    required this.delay,
  });

  factory DeptWiseStatus.fromJson(Map<String, dynamic> json) {
    return DeptWiseStatus(
      deptName: json['DEPT_NAME']?.toString() ?? '',
      total: json['TOTAL_INQM']?.toString() ?? '0',
      last30Days: json['THIS_MONTH_INQM']?.toString() ?? '0',
      onHand: json['ON_HAND_CNT']?.toString() ?? '0',
      overdue: json['OVERDUE_CNT']?.toString() ?? '0',
      successPercent: json['SUCCESS_PERCENT']?.toString() ?? '0',
      delay: json['FAIL_PERCENT']?.toString() ?? '0',
    );
  }
}

class CompanyWiseStatus {
  final String companyName;
  final String total;
  final String last30Days;
  final String onHand;
  final String overdue;
  final String successPercent;
  final String failPercent;

  CompanyWiseStatus({
    required this.companyName,
    required this.total,
    required this.last30Days,
    required this.onHand,
    required this.overdue,
    required this.successPercent,
    required this.failPercent,
  });

  factory CompanyWiseStatus.fromJson(Map<String, dynamic> json) {
    return CompanyWiseStatus(
      companyName: json['COMP_NAME']?.toString() ?? '',
      total: json['TOTAL_INQM']?.toString() ?? '0',
      last30Days: json['THIS_MONTH_INQM']?.toString() ?? '0',
      onHand: json['ON_HAND_CNT']?.toString() ?? '0',
      overdue: json['OVERDUE_CNT']?.toString() ?? '0',
      successPercent: json['SUCCESS_PERCENT']?.toString() ?? '0',
      failPercent: json['FAIL_PERCENT']?.toString() ?? '0',
    );
  }
}

class UserWiseStatus {
  final String userName;
  final String total;
  final String last30Days;
  final String onHand;
  final String overdue;
  final String successPercent;
  final String delay;

  UserWiseStatus({
    required this.userName,
    required this.total,
    required this.last30Days,
    required this.onHand,
    required this.overdue,
    required this.successPercent,
    required this.delay,
  });

  factory UserWiseStatus.fromJson(Map<String, dynamic> json) {
    return UserWiseStatus(
      userName: json['USER_NAME']?.toString() ?? '',
      total: json['TOTAL_TASK']?.toString() ?? '0',
      last30Days: json['THIS_MONTH_TASK']?.toString() ?? '0',
      onHand: json['ON_HAND_TASK']?.toString() ?? '0',
      overdue: json['OVERDUE_TASK']?.toString() ?? '0',
      successPercent: json['SUCCESS_PERCENT']?.toString() ?? '0',
      delay: json['FAIL_PERCENT']?.toString() ?? '0',
    );
  }
}

class DashboardFilterOption {
  final String id;
  final String name;

  DashboardFilterOption({required this.id, required this.name});

  factory DashboardFilterOption.fromJson(Map<String, dynamic> json) {
    return DashboardFilterOption(
      id: json['ID']?.toString() ?? '0',
      name: json['NAME']?.toString() ?? '',
    );
  }
}

class DashboardFilters {
  final List<DashboardFilterOption> companies;
  final List<DashboardFilterOption> groups;
  final List<DashboardFilterOption> depts;
  final List<DashboardFilterOption> subDepts;
  final List<DashboardFilterOption> tnaTypes;

  DashboardFilters({
    required this.companies,
    required this.groups,
    required this.depts,
    required this.subDepts,
    required this.tnaTypes,
  });

  DashboardFilters copyWith({
    List<DashboardFilterOption>? companies,
    List<DashboardFilterOption>? groups,
    List<DashboardFilterOption>? depts,
    List<DashboardFilterOption>? subDepts,
    List<DashboardFilterOption>? tnaTypes,
  }) {
    return DashboardFilters(
      companies: companies ?? this.companies,
      groups: groups ?? this.groups,
      depts: depts ?? this.depts,
      subDepts: subDepts ?? this.subDepts,
      tnaTypes: tnaTypes ?? this.tnaTypes,
    );
  }

  factory DashboardFilters.empty() => DashboardFilters(
        companies: [],
        groups: [],
        depts: [],
        subDepts: [],
        tnaTypes: [],
      );
}
