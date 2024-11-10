import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/api/api_client.dart';
import 'package:trealapp/core/utils/api_route.dart';

class NotificationRepo {
  ApiClient apiClient;
  SharedPreferences sharedPreferences;
  NotificationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getNotifications(
      String? page, String? perPage, String? status) async {
    return await apiClient.getData(
        "${ApiRoute.notifications}?page=$page&per_page=$perPage&status=$status");
  }

  Future<Response> readNotification(int id) async {
    return await apiClient.patchData("${ApiRoute.notifications}/$id/read", id);
  }
}
