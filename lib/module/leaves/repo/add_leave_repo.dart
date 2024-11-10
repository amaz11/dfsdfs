import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/api/api_client.dart';
import 'package:trealapp/core/utils/api_route.dart';

class AddLeaveRepo {
  ApiClient apiClient;
  SharedPreferences sharedPreferences;

  AddLeaveRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getLeaveType() async {
    return await apiClient.getData(ApiRoute.leaveType);
  }

  Future<Response> applyLeaveWithFile(File file) async {
    return await apiClient.uploadFileWithFormData(ApiRoute.fileUpload, file);
  }

  Future<Response> daysCount(Map<String, dynamic> data) async {
    return await apiClient.postData(ApiRoute.leaveDaysCount, data);
  }

  Future<Response> applyLeave(Map<String, dynamic> data) async {
    return await apiClient.postData(ApiRoute.leaves, data);
  }

  Future<Response> getAllLeave(String? page, String? perPage, String? startDate,
      String? endDate, String? status) async {
    if (status == null) {
      return await apiClient.getData(
          "${ApiRoute.leaves}?page=$page&start_date=$startDate&end_date=$endDate&per_page=$perPage");
    }
    return await apiClient.getData(
        "${ApiRoute.leaves}?status=$status&page=$page&start_date=$startDate&end_date=$endDate&per_page=$perPage");
  }

  Future<Response> deleteLeave(num data) async {
    return await apiClient.deleteData("${ApiRoute.leaves}/$data");
  }

  Future<Response> updateLeave(int id, Map<String, dynamic> data) async {
    return await apiClient.putData("${ApiRoute.leaves}/$id", data);
  }
}
