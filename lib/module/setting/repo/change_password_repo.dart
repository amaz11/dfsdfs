import 'package:get/get_connect/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/api/api_client.dart';
import 'package:trealapp/core/utils/api_route.dart';
import 'package:trealapp/core/utils/const_key.dart';

class ChangePasswordRepo {
  late ApiClient apiClient;
  late SharedPreferences sharedPreferences;
  ChangePasswordRepo(
      {required this.apiClient, required this.sharedPreferences});

  Future<Response> changePassword(Map<String, dynamic> body) async {
    return await apiClient.patchData(
      ApiRoute.changePassword,
      body,
    );
  }

  void removeFirstLogin() {
    sharedPreferences.remove(AppConstantkey.FIRST_LOGIN.key);
  }
}
