import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/api/api_client.dart';
import 'package:trealapp/core/utils/api_route.dart';

class CalenderRepo {
  ApiClient apiClient;
  SharedPreferences sharedPreferences;

  CalenderRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAllHoliday() async {
    return await apiClient.getData(ApiRoute.yearlyCalender);
  }
}
