import 'dart:convert';

AuthResponseModel authResponseModelFromJson(String str) =>
    AuthResponseModel.fromJson(json.decode(str));

class AuthResponseModel {
  final bool? success;
  final String? message;
  final String? token;

  AuthResponseModel({this.success, this.message, this.token});
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
          message: json["message"],
          success: json["success"],
          token: json["token"]);

  Map<String, dynamic> toJson() =>
      {"message": message, "success": success, "token": token};
}
