import 'dart:convert';

TodayAttendenceCheckModel todayAttendenceCheckModelFromJson(String str) =>
    TodayAttendenceCheckModel.fromJson(json.decode(str));

String attendanceSubmitModelToJson(TodayAttendenceCheckModel data) =>
    json.encode(data.toJson());

class TodayAttendenceCheckModel {
  final bool? success;
  final String? message;
  final TodayCheckAttendenceData? data;

  TodayAttendenceCheckModel({
    this.success,
    this.message,
    this.data,
  });

  factory TodayAttendenceCheckModel.fromJson(Map<String, dynamic> json) =>
      TodayAttendenceCheckModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] != null
            ? TodayCheckAttendenceData?.fromJson(json['data'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class TodayCheckAttendenceData {
  final String? checkIn;
  final String? checkOut;

  TodayCheckAttendenceData({this.checkIn, this.checkOut});

  factory TodayCheckAttendenceData.fromJson(Map<String, dynamic> json) =>
      TodayCheckAttendenceData(
          checkIn: json["check_in"], checkOut: json["check_out"]);

  Map<String, dynamic> toJson() => {"check_in": checkIn, "check_out": checkOut};
}
