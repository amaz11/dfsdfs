import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trealapp/core/utils/const_key.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/module/auth/repo/auth_repo.dart';
import 'package:trealapp/module/profile/model/profile_model.dart';

class DrawerControllerr extends GetxController with WidgetsBindingObserver {
  AuthRepo? authRepo;
  DrawerControllerr({this.authRepo});

  final RxString currentRoute = "".obs;
  late SharedPreferences sharedPreferences;
  final RxString userName = "".obs;
  final RxString userDesignation = "".obs;
  final RxString userProfileImg = "".obs;
  var profile = ProfileModel().obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    currentRoute.value = Get.currentRoute;
    if (currentRoute.value.isEmpty) return;
    fetchProfile();
  }

  Future<void> initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    getUser();
  }

  void setCurrentRoute() {
    currentRoute.value = Get.currentRoute;
  }

  void getUser() {
    String? name = sharedPreferences.getString(AppConstantkey.USERNAME.key);
    String? designation =
        sharedPreferences.getString(AppConstantkey.DESIGNATION.key);
    String? profileImg =
        sharedPreferences.getString(AppConstantkey.PROFILE_IMG.key);
    userName.value = name ?? "";
    userDesignation.value = designation ?? "";
    userProfileImg.value = profileImg ?? "";
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      Response responseUserProfile = await authRepo!.getUser();
      if (responseUserProfile.statusCode == 200) {
        ProfileModel profileModel =
            ProfileModel.fromJson(responseUserProfile.body);
        userName.value = profileModel.data?.firstName ?? "";
        userDesignation.value =
            profileModel.data?.employeeDesignationName ?? "";
        userProfileImg.value = profileModel.data?.profileImg ?? "";
      }
    } catch (e) {
      DialogUtils().errorSnackBar("An error occurred from fetch profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onFocus() async {
    await fetchProfile();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    await initializeSharedPreferences();
    onFocus();
  }
}
