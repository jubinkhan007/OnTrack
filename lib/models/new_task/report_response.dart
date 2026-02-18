class ReportSummary {
  final String last30Days;
  final String overdue;
  final String onQueue;
  final String upcoming;
  final String completed;
  final String running;

  ReportSummary({
    required this.last30Days,
    required this.overdue,
    required this.onQueue,
    required this.upcoming,
    required this.completed,
    required this.running,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      last30Days: json['LAST_30_DAYS']?.toString() ?? '0',
      overdue: json['OVERDUE']?.toString() ?? '0',
      onQueue: json['ON_QUEUE']?.toString() ?? '0',
      upcoming: json['UPCOMING']?.toString() ?? '0',
      completed: json['COMPLETED']?.toString() ?? '0',
      running: json['RUNNING']?.toString() ?? '0',
    );
  }

  factory ReportSummary.empty() => ReportSummary(
        last30Days: '0',
        overdue: '0',
        onQueue: '0',
        upcoming: '0',
        completed: '0',
        running: '0',
      );
}

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
      total: json['TOTAL']?.toString() ?? '0',
      last30Days: json['LAST_30_DAYS']?.toString() ?? '0',
      onHand: json['ON_HAND']?.toString() ?? '0',
      overdue: json['OVERDUE']?.toString() ?? '0',
      successPercent: json['SUCCESS_PERCENT']?.toString() ?? '0',
      delay: json['DELAY']?.toString() ?? '0',
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

  CompanyWiseStatus({
    required this.companyName,
    required this.total,
    required this.last30Days,
    required this.onHand,
    required this.overdue,
    required this.successPercent,
  });

  factory CompanyWiseStatus.fromJson(Map<String, dynamic> json) {
    return CompanyWiseStatus(
      companyName: json['COMPANY_NAME']?.toString() ?? '',
      total: json['TOTAL']?.toString() ?? '0',
      last30Days: json['LAST_30_DAYS']?.toString() ?? '0',
      onHand: json['ON_HAND']?.toString() ?? '0',
      overdue: json['OVERDUE']?.toString() ?? '0',
      successPercent: json['SUCCESS_PERCENT']?.toString() ?? '0',
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
      total: json['TOTAL']?.toString() ?? '0',
      last30Days: json['LAST_30_DAYS']?.toString() ?? '0',
      onHand: json['ON_HAND']?.toString() ?? '0',
      overdue: json['OVERDUE']?.toString() ?? '0',
      successPercent: json['SUCCESS_PERCENT']?.toString() ?? '0',
      delay: json['DELAY']?.toString() ?? '0',
    );
  }
}

class ReportData {
  final ReportSummary taskSummary;
  final ReportSummary tnaSummary;
  final List<DeptWiseStatus> deptWise;
  final List<CompanyWiseStatus> companyWise;
  final List<UserWiseStatus> userWise;

  ReportData({
    required this.taskSummary,
    required this.tnaSummary,
    required this.deptWise,
    required this.companyWise,
    required this.userWise,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      taskSummary: json['TASK_SUMMARY'] != null
          ? ReportSummary.fromJson(json['TASK_SUMMARY'])
          : ReportSummary.empty(),
      tnaSummary: json['TNA_SUMMARY'] != null
          ? ReportSummary.fromJson(json['TNA_SUMMARY'])
          : ReportSummary.empty(),
      deptWise: (json['DEPT_WISE'] as List? ?? [])
          .map((e) => DeptWiseStatus.fromJson(e))
          .toList(),
      companyWise: (json['COMPANY_WISE'] as List? ?? [])
          .map((e) => CompanyWiseStatus.fromJson(e))
          .toList(),
      userWise: (json['USER_WISE'] as List? ?? [])
          .map((e) => UserWiseStatus.fromJson(e))
          .toList(),
    );
  }

  factory ReportData.empty() => ReportData(
        taskSummary: ReportSummary.empty(),
        tnaSummary: ReportSummary.empty(),
        deptWise: [],
        companyWise: [],
        userWise: [],
      );
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
