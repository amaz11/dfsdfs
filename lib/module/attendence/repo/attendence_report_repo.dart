import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/api/api_client.dart';
import 'package:trealapp/core/utils/api_route.dart';

class AttendenceReportRepo {
  ApiClient apiClient;
  SharedPreferences sharedPreferences;
  AttendenceReportRepo(
      {required this.apiClient, required this.sharedPreferences});

  Future<Response> getAttendenceReport(
    String page,
    String perPage,
    String? startDate,
    String? endDate,
  ) async {
    return await apiClient.getData(
        "${ApiRoute.attendenceUrl}?page=$page&start_date=$startDate&end_date=$endDate&per_page=$perPage");
  }
}
