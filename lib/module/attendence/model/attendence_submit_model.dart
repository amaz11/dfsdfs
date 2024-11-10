import 'dart:convert';

AttendanceSubmitModel attendanceSubmitModelFromJson(String str) =>
    AttendanceSubmitModel.fromJson(json.decode(str));

String attendanceSubmitModelToJson(AttendanceSubmitModel data) =>
    json.encode(data.toJson());

class AttendanceSubmitModel {
  final bool? success;
  final String? message;
  final AttendanceData? data;

  AttendanceSubmitModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AttendanceSubmitModel.fromJson(Map<String, dynamic> json) =>
      AttendanceSubmitModel(
        success: json['success'],
        message: json['message'],
        data:
            json['data'] != null ? AttendanceData.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class AttendanceData {
  final String? date;
  final String? checkInTime;
  final String? checkOutTime;
  final String? inLatitude;
  final String? inLongitude;
  final String? outLatitude;
  final String? outLongitude;
  final dynamic isLate;
  final String? note;
  final String? adminNote;
  final String? updatedAt;
  final String? createdAt;
  final int? id;

  AttendanceData({
    this.date,
    this.checkInTime,
    this.checkOutTime,
    this.inLatitude,
    this.inLongitude,
    this.outLatitude,
    this.outLongitude,
    this.isLate,
    this.note,
    this.adminNote,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
        id: json['id'],
        date: json['date'],
        checkInTime: json['check_in_time'],
        checkOutTime: json['check_out_time'],
        inLatitude: json['in_latitude'],
        inLongitude: json['in_longitude'],
        outLatitude: json['out_latitude'],
        outLongitude: json['out_longitude'],
        isLate: json['is_late'],
        note: json['note'],
        adminNote: json["admin_note"],
        updatedAt: json['updated_at'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'check_in_time': checkInTime,
        'in_latitude': inLatitude,
        'in_longitude': inLongitude,
        'is_late': isLate,
        'note': note,
        'updated_at': updatedAt,
        'created_at': createdAt,
        'id': id,
      };
}
