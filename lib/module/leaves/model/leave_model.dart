// To parse this JSON data, do
//
//     final leaveModel = leaveModelFromJson(jsonString);

import 'dart:convert';

import 'package:trealapp/module/attendence/model/attendence_report_model.dart';

LeaveModel leaveModelFromJson(String str) =>
    LeaveModel.fromJson(json.decode(str));

String leaveModelToJson(LeaveModel data) => json.encode(data.toJson());

class LeaveModel {
  bool? success;
  String? message;
  TotalLeaveSummary? totalLeaveSummary;
  List<LeaveTypeSummary>? leaveTypeSummary;
  List<Leaves>? leaves;
  Pagination? pagination;

  LeaveModel({
    this.success,
    this.message,
    this.totalLeaveSummary,
    this.leaveTypeSummary,
    this.leaves,
    this.pagination,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) => LeaveModel(
        success: json["success"],
        message: json["message"],
        totalLeaveSummary: json["total_leave_summary"] == null
            ? null
            : TotalLeaveSummary.fromJson(json["total_leave_summary"]),
        leaveTypeSummary: json["leave_type_summary"] == null
            ? []
            : List<LeaveTypeSummary>.from(json["leave_type_summary"]!
                .map((x) => LeaveTypeSummary.fromJson(x))),
        leaves: json["leaves"] == null
            ? []
            : List<Leaves>.from(json["leaves"]!.map((x) => Leaves.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "total_leave_summary": totalLeaveSummary?.toJson(),
        "leave_type_summary": leaveTypeSummary == null
            ? []
            : List<dynamic>.from(leaveTypeSummary!.map((x) => x.toJson())),
        "leaves": leaves == null
            ? []
            : List<dynamic>.from(leaves!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class LeaveTypeSummary {
  int? id;
  dynamic leaveType;
  dynamic totalEntitlement;
  dynamic usedDays;
  dynamic remainingDays;

  LeaveTypeSummary({
    this.id,
    this.leaveType,
    this.totalEntitlement,
    this.usedDays,
    this.remainingDays,
  });

  factory LeaveTypeSummary.fromJson(Map<String, dynamic> json) =>
      LeaveTypeSummary(
        id: json["id"],
        leaveType: json["leave_type"].toString(),
        totalEntitlement: json["total_entitlement"].toString(),
        usedDays: json["used_days"].toString(),
        remainingDays: json["remaining_days"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "leave_type": leaveType,
        "total_entitlement": totalEntitlement,
        "used_days": usedDays,
        "remaining_days": remainingDays,
      };
}

class Leaves {
  int? id;
  dynamic fromDate;
  dynamic toDate;
  dynamic leaveApplyDate;
  dynamic isHalfDay;
  dynamic firstHalf;
  dynamic days;
  dynamic reason;
  dynamic attachment;
  dynamic leaveTypeId;
  String? leaveTypeName;
  dynamic status;
  String? statusText;
  List<History>? history;

  Leaves({
    this.id,
    this.fromDate,
    this.toDate,
    this.leaveApplyDate,
    this.isHalfDay,
    this.firstHalf,
    this.days,
    this.reason,
    this.attachment,
    this.leaveTypeId,
    this.leaveTypeName,
    this.status,
    this.statusText,
    this.history,
  });

  factory Leaves.fromJson(Map<String, dynamic> json) => Leaves(
        id: json["id"],
        fromDate: json["from_date"].toString(),
        toDate: json["to_date"].toString(),
        leaveApplyDate: json["leave_apply_date"].toString(),
        isHalfDay: json["is_half_day"].toString(),
        firstHalf: json["first_half"].toString(),
        days: json["days"].toString(),
        reason: json["reason"],
        attachment: json["attachment"],
        leaveTypeId: int.parse(json["leave_type_id"].toString()),
        leaveTypeName: json["leave_type_name"],
        status: json["status"].toString(),
        statusText: json["status_text"],
        history: json["history"] == null
            ? []
            : List<History>.from(
                json["history"]!.map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from_date": fromDate,
        "to_date": toDate,
        "leave_apply_date": leaveApplyDate,
        "is_half_day": isHalfDay,
        "first_half": firstHalf,
        "days": days,
        "reason": reason,
        "attachment": attachment,
        "leave_type_id": leaveTypeId,
        "leave_type_name": leaveTypeName,
        "status": status,
        "status_text": statusText,
        "history": history == null
            ? []
            : List<dynamic>.from(history!.map((x) => x.toJson())),
      };
}

class History {
  int? id;
  dynamic approved;
  dynamic approverPriority;
  String? approverFirstName;
  String? approverLastName;
  String? approverUsername;
  String? approverEmail;
  String? approverDesignation;
  String? approverDepartment;
  String? note;

  History(
      {this.id,
      this.approved,
      this.approverPriority,
      this.approverFirstName,
      this.approverLastName,
      this.approverUsername,
      this.approverEmail,
      this.approverDesignation,
      this.approverDepartment,
      this.note});

  factory History.fromJson(Map<String, dynamic> json) => History(
      id: json["id"],
      approved: json["approved"].toString(),
      approverPriority: json["approver_priority"].toString(),
      approverFirstName: json["approver_first_name"],
      approverLastName: json["approver_last_name"],
      approverUsername: json["approver_username"],
      approverEmail: json["approver_email"],
      approverDesignation: json["approver_designation"],
      approverDepartment: json["approver_department"],
      note: json["note"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "approved": approved,
        "approver_priority": approverPriority,
        "approver_first_name": approverFirstName,
        "approver_last_name": approverLastName,
        "approver_username": approverUsername,
        "approver_email": approverEmail,
        "approver_designation": approverDesignation,
        "approver_department": approverDepartment,
        "note": note
      };
}

class TotalLeaveSummary {
  dynamic totalEntitlement;
  dynamic usedDays;
  dynamic remainingDays;

  TotalLeaveSummary({
    this.totalEntitlement,
    this.usedDays,
    this.remainingDays,
  });

  factory TotalLeaveSummary.fromJson(Map<String, dynamic> json) =>
      TotalLeaveSummary(
        totalEntitlement: json["total_entitlement"].toString(),
        usedDays: json["used_days"].toString(),
        remainingDays: json["remaining_days"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "total_entitlement": totalEntitlement,
        "used_days": usedDays,
        "remaining_days": remainingDays,
      };
}
