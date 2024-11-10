import 'package:get/get.dart';
// import 'package:get/get_connect/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/api/api_client.dart';
import 'package:trealapp/core/utils/api_route.dart';
// import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/const_key.dart';

class AuthRepo {
  late ApiClient apiClient;
  late final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(Map<String, dynamic> body) async {
    return await apiClient.postData(ApiRoute.loginUrl, body);
  }

  Future<Response> getUser() async {
    return await apiClient.getData(ApiRoute.userProfile);
  }

  saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    await sharedPreferences.setString(AppConstantkey.TOKEN.key, token);
  }

  saveUserName(String name, String designation) async {
    await sharedPreferences.setString(
        AppConstantkey.USERNAME.key, name.toString());

    await sharedPreferences.setString(
        AppConstantkey.DESIGNATION.key, designation.toString());
  }

  saveProfileImgAndDesignation(String? img) async {
    await sharedPreferences.setString(
        AppConstantkey.PROFILE_IMG.key, img!.toString());
  }

  String? getUserName() {
    String? name = sharedPreferences.getString(AppConstantkey.USERNAME.key);
    return name;
  }

  saveFirstLogin(String firstLogin) async {
    await sharedPreferences.setString(
        AppConstantkey.FIRST_LOGIN.key, firstLogin);
  }

  void logout() {
    sharedPreferences.clear();
    apiClient.token = '';
    apiClient.updateHeader('');
  }

  Object userLoggedIn() {
    // Check if the key exists and the value is true
    return sharedPreferences.getString(AppConstantkey.TOKEN.key) ?? false;
  }

  bool userLoggedOut() {
    // Check if the key exists and the value is true
    return sharedPreferences.containsKey(AppConstantkey.TOKEN.key);
  }

  Future<String> getUserToken() async {
    //PrefHelper.getString(AppConstantKey.TOKEN.key);
    return sharedPreferences.getString(AppConstantkey.TOKEN.key) ?? "";
  }
}
