import 'dart:convert';

AttendanceReportModel attendanceReportModelFromJson(String str) =>
    AttendanceReportModel.fromJson(json.decode(str));

String attendanceReportModelToJson(AttendanceReportModel data) =>
    json.encode(data.toJson());

class AttendanceReportModel {
  final bool? success;
  final List<AttendanceData>? data;
  final Pagination? pagination;

  AttendanceReportModel({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory AttendanceReportModel.fromJson(Map<String, dynamic> json) =>
      AttendanceReportModel(
        success: json['success'],
        data: json['data'] != null
            ? List<AttendanceData>.from(
                json['data'].map((x) => AttendanceData.fromJson(x)))
            : null,
        pagination: json['pagination'] != null
            ? Pagination.fromJson(json['pagination'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((x) => x.toJson()).toList(),
        'pagination': pagination?.toJson(),
      };
}

class AttendanceData {
  final int? id;
  final String? date;
  final String? checkInTime;
  final String? checkOutTime;
  final String? inLatitude;
  final String? inLongitude;
  final String? outLatitude;
  final String? outLongitude;
  final String? note;
  final String? adminNote;
  final dynamic isLate;
  final String? createdAt;
  final String? updatedAt;

  AttendanceData({
    this.id,
    this.date,
    this.checkInTime,
    this.checkOutTime,
    this.inLatitude,
    this.inLongitude,
    this.outLatitude,
    this.outLongitude,
    this.note,
    this.adminNote,
    this.isLate,
    this.createdAt,
    this.updatedAt,
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
        note: json['note'],
        adminNote: json['admin_note'],
        isLate: json['is_late'].toString(),
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'check_in_time': checkInTime,
        'check_out_time': checkOutTime,
        'in_latitude': inLatitude,
        'in_longitude': inLongitude,
        'out_latitude': outLatitude,
        'out_longitude': outLongitude,
        'note': note,
        'admin_note': adminNote,
        'is_late': isLate,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class Pagination {
  final dynamic total;
  final dynamic currentPage;
  final dynamic perPage;
  final dynamic lastPage;
  final dynamic from;
  final dynamic to;

  Pagination({
    this.total,
    this.currentPage,
    this.perPage,
    this.lastPage,
    this.from,
    this.to,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json['total'].toString(),
        currentPage: json['current_page'].toString(),
        perPage: json['per_page'].toString(),
        lastPage: json['last_page'].toString(),
        from: json['from'].toString(),
        to: json['to'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'current_page': currentPage,
        'per_page': perPage,
        'last_page': lastPage,
        'from': from,
        'to': to,
      };
}
