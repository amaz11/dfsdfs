import 'dart:convert';
import 'package:trealapp/module/attendence/model/attendence_report_model.dart';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  final bool? success;
  final List<NotificationData>? data;
  final Pagination? pagination;

  NotificationModel({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        success: json['success'],
        data: json['data'] != null
            ? List<NotificationData>.from(
                json['data'].map((x) => NotificationData.fromJson(x)))
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

class NotificationData {
  final int? id;
  final dynamic userId;
  final String? notificationType;
  final String? title;
  final String? message;
  final dynamic read;
  final String? notifiedAt;

  NotificationData({
    this.id,
    this.userId,
    this.notificationType,
    this.title,
    this.message,
    this.read,
    this.notifiedAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json['id'],
        userId: json['user_id'].toString(),
        notificationType: json['notification_type'],
        title: json['title'],
        message: json['message'],
        read: json['read'].toString(),
        notifiedAt: json['notified_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'notification_type': notificationType,
        'title': title,
        'message': message,
        'read': read,
        'notified_at': notifiedAt,
      };
}
