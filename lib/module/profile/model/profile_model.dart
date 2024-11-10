import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) =>
    json.decode(data.toJson() as String);

class ProfileModel {
  final bool? success;
  final Data? data;

  ProfileModel({this.success, this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        success: json['success'],
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}

class Data {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final String? presentAddress;
  final String? permanentAddress;
  final String? profileImg;
  final String? firstLogin;
  final String? joiningDate;
  final String? manageEmployee;
  final String? manageLeave;
  final String? manageTask;
  final String? manageAttendance;
  final String? manageExpense;
  final String? companyName;
  final String? phoneNo;
  final String? status;
  final String? departmentName;
  final String? employeeDesignationName;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.presentAddress,
      this.permanentAddress,
      this.profileImg,
      this.firstLogin,
      this.joiningDate,
      this.manageEmployee,
      this.manageLeave,
      this.manageTask,
      this.manageAttendance,
      this.manageExpense,
      this.companyName,
      this.phoneNo,
      this.status,
      this.departmentName,
      this.employeeDesignationName});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        username: json['username'],
        email: json['email'],
        presentAddress: json['present_address'],
        permanentAddress: json['permanent_address'],
        profileImg: json["profile_img"].toString(),
        firstLogin: json['first_login'].toString(),
        joiningDate: json['joining_date'],
        manageEmployee: json["manage_employee"].toString(),
        manageLeave: json['manage_leave'].toString(),
        manageTask: json['manage_task'].toString(),
        manageAttendance: json['manage_attendance'].toString(),
        manageExpense: json['manage_expense'].toString(),
        phoneNo: json['phone_no'].toString(),
        status: json['status'].toString(),
        departmentName: json['department_name'],
        employeeDesignationName: json['employee_designation_name'],
        companyName: json['company_name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'present_address': presentAddress,
        'permanent_address': permanentAddress,
        'first_login': firstLogin,
        'joining_date': joiningDate,
        'manage_leave': manageLeave,
        'manage_task': manageTask,
        'manage_attendance': manageAttendance,
        'manage_expense': manageExpense,
        'department_name': departmentName,
        'company_name': companyName,
        'employee_designation_name': employeeDesignationName,
        'phone_no': phoneNo,
        'status': status,
        "profile_img": profileImg
      };
}
