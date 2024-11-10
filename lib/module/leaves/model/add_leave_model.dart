import 'dart:convert';

AddLeaveModel addLeaveModelFromJson(String str) =>
    AddLeaveModel.fromJson(json.decode(str));

String addLeaveModelToJson(AddLeaveModel data) => json.encode(data.toJson());

class AddLeaveModel {
  bool? success;
  String? message;
  List<LeaveType>? leaveTypes;

  AddLeaveModel({
    this.success,
    this.message,
    this.leaveTypes,
  });

  factory AddLeaveModel.fromJson(Map<String, dynamic> json) => AddLeaveModel(
        success: json["success"],
        message: json["message"],
        leaveTypes: json["leaveTypes"] == null
            ? []
            : List<LeaveType>.from(
                json["leaveTypes"]!.map((x) => LeaveType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "leaveTypes": leaveTypes == null
            ? []
            : List<dynamic>.from(leaveTypes!.map((x) => x.toJson())),
      };
}

class LeaveType {
  int? id;
  String? leaveTypeName;
  dynamic days;

  LeaveType({
    this.id,
    this.leaveTypeName,
    this.days,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) => LeaveType(
        id: json["id"],
        leaveTypeName: json["leave_type_name"],
        days: json["days"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "leave_type_name": leaveTypeName,
        "days": days,
      };
}
