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

class ReportFilterOption {
  final String id;
  final String name;

  ReportFilterOption({required this.id, required this.name});

  factory ReportFilterOption.fromJson(Map<String, dynamic> json) {
    return ReportFilterOption(
      id: json['ID']?.toString() ?? '0',
      name: json['NAME']?.toString() ?? '',
    );
  }
}

class ReportFilters {
  final List<ReportFilterOption> groups;
  final List<ReportFilterOption> depts;
  final List<ReportFilterOption> subDepts;
  final List<ReportFilterOption> tnaTypes;

  ReportFilters({
    required this.groups,
    required this.depts,
    required this.subDepts,
    required this.tnaTypes,
  });

  factory ReportFilters.fromJson(Map<String, dynamic> json) {
    return ReportFilters(
      groups: (json['GROUPS'] as List? ?? [])
          .map((e) => ReportFilterOption.fromJson(e))
          .toList(),
      depts: (json['DEPTS'] as List? ?? [])
          .map((e) => ReportFilterOption.fromJson(e))
          .toList(),
      subDepts: (json['SUB_DEPTS'] as List? ?? [])
          .map((e) => ReportFilterOption.fromJson(e))
          .toList(),
      tnaTypes: (json['TNA_TYPES'] as List? ?? [])
          .map((e) => ReportFilterOption.fromJson(e))
          .toList(),
    );
  }

  factory ReportFilters.empty() => ReportFilters(
        groups: [],
        depts: [],
        subDepts: [],
        tnaTypes: [],
      );
}
