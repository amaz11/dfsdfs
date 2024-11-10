import 'dart:convert';

CompanyDetailsModel companyDetailsModelFromJson(String str) =>
    CompanyDetailsModel.fromJson(json.decode(str));

String companyDetailsModelToJson(CompanyDetailsModel data) =>
    json.encode(data.toJson());

class CompanyDetailsModel {
  final bool? success;
  final String? message;
  final CompanyData? data;

  CompanyDetailsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CompanyDetailsModel.fromJson(Map<String, dynamic> json) =>
      CompanyDetailsModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] != null ? CompanyData.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class CompanyData {
  final int? id;
  final String? companyName;
  final String? companyAddress;
  final String? companyType;
  final dynamic employeeCount;
  final dynamic totalYearlyLeaves;
  final String? officeStartTime;
  final String? officeEndTime;
  final String? timezone;
  final dynamic lateThresholdMinutes;

  CompanyData(
      {this.id,
      this.companyName,
      this.companyAddress,
      this.companyType,
      this.employeeCount,
      this.totalYearlyLeaves,
      this.officeStartTime,
      this.officeEndTime,
      this.timezone,
      this.lateThresholdMinutes});

  factory CompanyData.fromJson(Map<String, dynamic> json) => CompanyData(
      id: json['id'],
      companyName: json['company_name'],
      companyAddress: json['company_address'],
      companyType: json['company_type'],
      employeeCount: json['employee_count'].toString(),
      totalYearlyLeaves: json['total_yearly_leaves'].toString(),
      officeStartTime: json['office_start_time'],
      officeEndTime: json['office_end_time'],
      timezone: json["timezone"],
      lateThresholdMinutes: json["late_threshold_minutes"].toString());

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_name': companyName,
        'company_address': companyAddress,
        'company_type': companyType,
        'employee_count': employeeCount,
        'total_yearly_leaves': totalYearlyLeaves,
        'office_start_time': officeStartTime,
        'office_end_time': officeEndTime,
        'timezone': timezone,
        'late_threshold_minutes': lateThresholdMinutes
      };
}
