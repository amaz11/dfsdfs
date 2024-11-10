// To parse this JSON data, do
//
//     final approvalCheckModal = approvalCheckModalFromJson(jsonString);

import 'dart:convert';

ApprovalCheckModal approvalCheckModalFromJson(String str) =>
    ApprovalCheckModal.fromJson(json.decode(str));

String approvalCheckModalToJson(ApprovalCheckModal data) =>
    json.encode(data.toJson());

class ApprovalCheckModal {
  bool? success;
  String? message;
  Data? data;

  ApprovalCheckModal({
    this.success,
    this.message,
    this.data,
  });

  factory ApprovalCheckModal.fromJson(Map<String, dynamic> json) =>
      ApprovalCheckModal(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  bool? canManageLeave;
  bool? canManageExpense;

  Data({
    this.canManageLeave,
    this.canManageExpense,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        canManageLeave: json["can_manage_leave"],
        canManageExpense: json["can_manage_expense"],
      );

  Map<String, dynamic> toJson() => {
        "can_manage_leave": canManageLeave,
        "can_manage_expense": canManageExpense,
      };
}
