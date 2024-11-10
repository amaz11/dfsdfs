// To parse this JSON data, do
//
//     final loliday = lolidayFromJson(jsonString);

import 'dart:convert';

Holiday holidayFromJson(String str) => Holiday.fromJson(json.decode(str));

String holidayToJson(Holiday data) => json.encode(data.toJson());

class Holiday {
  bool? success;
  List<Datum>? data;

  Holiday({
    this.success,
    this.data,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) => Holiday(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? companyDetailId;
  String? name;
  String? startDate;
  String? endDate;
  String? days;

  Datum({
    this.companyDetailId,
    this.name,
    this.startDate,
    this.endDate,
    this.days,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        companyDetailId: json["company_detail_id"],
        name: json["name"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        days: json["days"],
      );

  Map<String, dynamic> toJson() => {
        "company_detail_id": companyDetailId,
        "name": name,
        "start_date": startDate,
        "end_date": endDate,
        "days": days,
      };
}
