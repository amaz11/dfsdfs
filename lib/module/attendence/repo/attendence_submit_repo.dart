import 'package:get/get_connect/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/api/api_client.dart';
import 'package:trealapp/core/utils/api_route.dart';

class AttendenceSubmitRepo {
  late ApiClient apiClient;
  late SharedPreferences sharedPreferences;

  AttendenceSubmitRepo(
      {required this.apiClient, required this.sharedPreferences});
  Future<Response> submitCheckIN(Map<String, dynamic> body) async {
    return await apiClient.postData(ApiRoute.checkInUrl, body);
  }

  Future<Response> submitCheckOut(Map<String, dynamic> body) async {
    return await apiClient.patchData(ApiRoute.checkOutUrl, body);
  }

  Future<Response> sendLateInNote(Map<String, dynamic> body) async {
    return await apiClient.patchData(ApiRoute.sendAttendenceNote, body);
  }

  Future<Response> userTodayAttendence() async {
    return await apiClient.getData(ApiRoute.todayAttendenceCheckUrl);
  }

  Future<Response> userCompanyDetails() async {
    return await apiClient.getData(ApiRoute.companyDetails);
  }

  Future<Response> getCurrentTime() async {
    return await apiClient.getData(ApiRoute.currentTime);
  }
}
