// To parse this JSON data, do
//
//     final leaveDaysCount = leaveDaysCountFromJson(jsonString);

import 'dart:convert';

LeaveDaysCount leaveDaysCountFromJson(String str) =>
    LeaveDaysCount.fromJson(json.decode(str));

String leaveDaysCountToJson(LeaveDaysCount data) => json.encode(data.toJson());

class LeaveDaysCount {
  bool? success;
  Data? data;

  LeaveDaysCount({
    this.success,
    this.data,
  });

  factory LeaveDaysCount.fromJson(Map<String, dynamic> json) => LeaveDaysCount(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  dynamic days;

  Data({
    this.days,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        days: json["days"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "days": days,
      };
}
