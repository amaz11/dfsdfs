// To parse this JSON data, do
//
//     final yearlyCalenderModel = yearlyCalenderModelFromJson(jsonString);

import 'dart:convert';

YearlyCalenderModel yearlyCalenderModelFromJson(String str) =>
    YearlyCalenderModel.fromJson(json.decode(str));

String yearlyCalenderModelToJson(YearlyCalenderModel data) =>
    json.encode(data.toJson());

class YearlyCalenderModel {
  bool? success;
  String? message;
  Data? data;

  YearlyCalenderModel({
    this.success,
    this.message,
    this.data,
  });

  factory YearlyCalenderModel.fromJson(Map<String, dynamic> json) =>
      YearlyCalenderModel(
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
  List<String>? weekends;
  List<Holiday>? holidays;
  List<Leaves>? leaves;

  Data({
    this.weekends,
    this.holidays,
    this.leaves,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        weekends: json["weekends"] == null
            ? []
            : List<String>.from(json["weekends"]!.map((x) => x)),
        holidays: json["holidays"] == null
            ? []
            : List<Holiday>.from(
                json["holidays"]!.map((x) => Holiday.fromJson(x))),
        leaves: json["leaves"] == null
            ? []
            : List<Leaves>.from(json["leaves"]!.map((x) => Leaves.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "weekends":
            weekends == null ? [] : List<dynamic>.from(weekends!.map((x) => x)),
        "holidays": holidays == null
            ? []
            : List<dynamic>.from(holidays!.map((x) => x.toJson())),
        "leaves": leaves == null
            ? []
            : List<dynamic>.from(leaves!.map((x) => x.toJson())),
      };
}

class Holiday {
  String? name;
  String? startDate;
  String? endDate;
  dynamic days;

  Holiday({
    this.name,
    this.startDate,
    this.endDate,
    this.days,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) => Holiday(
        name: json["name"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        days: json["days"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "start_date": startDate,
        "end_date": endDate,
        "days": days,
      };
}

class Leaves {
  int? leaveTypeId;
  String? fromDate;
  String? toDate;
  String? leaveApplyDate;
  dynamic isHalfDay;
  dynamic days;
  String? reason;
  dynamic attachment;

  Leaves({
    this.leaveTypeId,
    this.fromDate,
    this.toDate,
    this.leaveApplyDate,
    this.isHalfDay,
    this.days,
    this.reason,
    this.attachment,
  });

  factory Leaves.fromJson(Map<String, dynamic> json) => Leaves(
        leaveTypeId: json["leave_type_id"],
        fromDate: json["from_date"],
        toDate: json["to_date"],
        isHalfDay: json["is_half_day"].toString(),
        days: json["days"].toString(),
        reason: json["reason"],
        attachment: json["attachment"],
      );

  Map<String, dynamic> toJson() => {
        "leave_type_id": leaveTypeId,
        "from_date": fromDate,
        "to_date": toDate!,
        "leave_apply_date": leaveApplyDate,
        "is_half_day": isHalfDay,
        "days": days,
        "reason": reason,
        "attachment": attachment,
      };
}
