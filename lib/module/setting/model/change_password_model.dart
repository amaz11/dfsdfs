import 'dart:convert';

ChangePasswordModel changePasswordModelFromJson(String str) =>
    ChangePasswordModel.fromJson(json.decode(str));

class ChangePasswordModel {
  final bool? success;
  final String? message;
  ChangePasswordModel({this.message, this.success});

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) =>
      ChangePasswordModel(message: json["message"], success: json["success"]);

  Map<String, dynamic> toJson() => {"message": message, "success": success};
}
