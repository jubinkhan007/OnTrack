class BuResponse {
  final List<BusinessUnit> bu;

  BuResponse({required this.bu});

  factory BuResponse.fromJson(Map<String, dynamic> json) {
    return BuResponse(
      bu: (json['BU'] as List)
          .map((item) => BusinessUnit.fromJson(item))
          .toList(),
    );
  }
}

class BusinessUnit {
  final String compId;
  final String userId;
  final String userHris;
  final String userName;
  final String searchName;
  final String displayName;

  BusinessUnit({
    required this.compId,
    required this.userId,
    required this.userHris,
    required this.userName,
    required this.searchName,
    required this.displayName,
  });

  factory BusinessUnit.fromJson(Map<String, dynamic> json) {
    return BusinessUnit(
      compId: json['COMP_ID'].toString(),
      userId: json['USER_ID'].toString(),
      userHris: json['USER_HRIS'].toString(),
      userName: json['USER_NAME'].toString(),
      searchName: json['SEARCH_NAME'].toString(),
      displayName: json['DISPLAY_NAME'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'COMP_ID': compId,
      'USER_ID': userId,
      'USER_HRIS': userHris,
      'USER_NAME': userName,
      'SEARCH_NAME': searchName,
      'DISPLAY_NAME': displayName,
    };
  }
}
