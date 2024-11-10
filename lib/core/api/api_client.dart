import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/utils/const_key.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    token = sharedPreferences.getString(AppConstantkey.TOKEN.key) ?? "";
    timeout = const Duration(seconds: 30);
    _mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(String url, {Map<String, String>? headers}) async {
    try {
      Response response =
          await get(Uri.encodeFull(url), headers: headers ?? _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(
    String url,
    dynamic body,
  ) async {
    try {
      Response response =
          await post(url, jsonEncode(body), headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> patchData(String url, dynamic body) async {
    try {
      Response response =
          await patch(url, jsonEncode(body), headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> putData(String url, dynamic body) async {
    try {
      Response response =
          await put(url, jsonEncode(body), headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(String url) async {
    try {
      Response response = await delete(url, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // Multipart POST request for File Uploads
  Future<Response> uploadFileWithFormData(String url, File file) async {
    try {
      final form = FormData({
        'file': MultipartFile(
          file,
          filename: file.path.split('/').last,
          contentType: 'application/octet-stream',
        ),
      });

      final response = await post(url, form, headers: {
        'Authorization': 'Bearer $token',
      });

      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
