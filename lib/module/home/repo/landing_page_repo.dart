import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/api/api_client.dart';
import 'package:trealapp/core/utils/api_route.dart';

class LandingPageRepo {
  ApiClient apiClient;
  SharedPreferences sharedPreferences;
  LandingPageRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getCheckApproval() async {
    return await apiClient.getData(ApiRoute.checkApproval);
  }
}
