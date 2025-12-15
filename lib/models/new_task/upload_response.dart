import 'dart:convert';

class StructuredData {
  final String name;
  final String title;
  final String company;
  final String email;
  final String phone;
  final String mobile;
  final String address;
  final String website;
  final String other;

  StructuredData({
    required this.name,
    required this.title,
    required this.company,
    required this.email,
    required this.phone,
    required this.mobile,
    required this.address,
    required this.website,
    required this.other,
  });

  factory StructuredData.fromJson(Map<String, dynamic> json) {
    return StructuredData(
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      mobile: json['mobile'] ?? '',
      address: json['address'] ?? '',
      website: json['website'] ?? '',
      other: json['other'] ?? '',
    );
  }
}

class UploadResponse {
  final bool success;
  final String staffId;
  final String uniqueId;
  final String error;
  final String hrisEmail;
  final StructuredData structuredData;

  UploadResponse({
    required this.success,
    required this.staffId,
    required this.uniqueId,
    required this.error,
    required this.hrisEmail,
    required this.structuredData,
  });

  factory UploadResponse.fromJson(String jsonString) {
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    return UploadResponse(
      success: jsonData['success'] ?? false,
      staffId: jsonData['staffId'] ?? '',
      uniqueId: jsonData['uniqueId'] ?? '',
      error: jsonData['error'] ?? '',
      hrisEmail: jsonData['hris_email'] ?? '',
      structuredData: jsonData['structured_data'] != null
          ? StructuredData.fromJson(jsonData['structured_data'])
          : StructuredData(
        name: '',
        title: '',
        company: '',
        email: '',
        phone: '',
        mobile: '',
        address: '',
        website: '',
        other: '',
      ),
    );
  }
}
