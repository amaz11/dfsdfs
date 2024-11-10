// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/module/auth/repo/auth_repo.dart';
import 'package:trealapp/module/profile/model/profile_model.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AuthRepo? authRepo;

  ProfileController({this.authRepo}) {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        // Detect swipe
        setTabAndFetch(tabController.index);
      }
    });
  }
  var profile = ProfileModel().obs;
  var isLoading = true.obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void setTabAndFetch(int index) async {
    // switchCageOfLeaveMethod(index);
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      Response responseUserProfile = await authRepo!.getUser();
      if (responseUserProfile.statusCode == 200) {
        ProfileModel profileModel =
            ProfileModel.fromJson(responseUserProfile.body);
        profile.value = profileModel;
      }
    } catch (e) {
      DialogUtils().errorSnackBar("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
