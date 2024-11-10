// To parse this JSON data, do
//
//     final leaveApprovalModel = leaveApprovalModelFromJson(jsonString);

import 'dart:convert';

import 'package:trealapp/module/leaves/model/leave_model.dart';

LeaveApprovalModel leaveApprovalModelFromJson(String str) =>
    LeaveApprovalModel.fromJson(json.decode(str));

String leaveApprovalModelToJson(LeaveApprovalModel data) =>
    json.encode(data.toJson());

class LeaveApprovalModel {
  bool? success;
  String? message;
  List<Datum>? data;

  LeaveApprovalModel({
    this.success,
    this.message,
    this.data,
  });

  factory LeaveApprovalModel.fromJson(Map<String, dynamic> json) =>
      LeaveApprovalModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? leaveTypeName;
  String? fromDate;
  String? toDate;
  dynamic leaveApplyDate;
  dynamic isHalfDay;
  dynamic firstHalf;
  int? days;
  dynamic reason;
  dynamic attachment;
  dynamic status;
  User? user;
  List<History>? history;

  Datum({
    this.id,
    this.leaveTypeName,
    this.fromDate,
    this.toDate,
    this.leaveApplyDate,
    this.isHalfDay,
    this.firstHalf,
    this.days,
    this.reason,
    this.attachment,
    this.status,
    this.user,
    this.history,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        leaveTypeName: json["leave_type_name"].toString(),
        fromDate: json["from_date"].toString(),
        toDate: json["to_date"].toString(),
        leaveApplyDate: json["leave_apply_date"].toString(),
        isHalfDay: json["is_half_day"],
        firstHalf: json["first_half"].toString(),
        days: json["days"],
        reason: json["reason"],
        attachment: json["attachment"],
        status: json["status"].toString(),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        history: json["history"] == null
            ? []
            : List<History>.from(
                json["history"]!.map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "leave_type_name": leaveTypeName,
        "from_date": fromDate,
        "to_date": toDate,
        "leave_apply_date": leaveApplyDate,
        "is_half_day": isHalfDay,
        "first_half": firstHalf,
        "days": days,
        "reason": reason,
        "attachment": attachment,
        "status": status,
        "user": user?.toJson(),
        "history": history == null
            ? []
            : List<dynamic>.from(history!.map((x) => x.toJson())),
      };
}

class User {
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? employeeDesignation;
  String? employeeDepartment;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.employeeDesignation,
    this.employeeDepartment,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        username: json["username"],
        employeeDesignation: json["employee_designation"],
        employeeDepartment: json["employee_department"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "username": username,
        "employee_designation": employeeDesignation,
        "employee_department": employeeDepartment,
      };
}
