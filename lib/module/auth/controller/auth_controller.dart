import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/module/auth/controller/drawer_controller.dart';
import 'package:trealapp/module/auth/model/auth_response_model.dart';
import 'package:trealapp/module/auth/repo/auth_repo.dart';
import 'package:trealapp/module/profile/model/profile_model.dart';

class AuthController extends GetxController {
  AuthRepo? authRepo;
  AuthController({this.authRepo});
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocuseNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Rx<Color> emailPrefixIconColor = blueColor.obs;
  Rx<Color> passwordPrefixIconColor = blueColor.obs;

  late bool result = false;
  final RxBool obscureText = true.obs;

  final DrawerControllerr drawerController =
      Get.put<DrawerControllerr>(DrawerControllerr());
  set passwordVisible(bool value) {
    obscureText.value = value;
    update();
  }

  bool get passwordVisible => obscureText.value;

  void onInt() {
    super.onInit();
    emailFocusNode.addListener(_handleEmailFocuseChange);
    passwordFocuseNode.addListener(_handlePasswordFocuseChange);
    result = passwordFocuseNode.hasFocus;
  }

  _handleEmailFocuseChange() {
    if (emailFocusNode.hasFocus) {
      emailPrefixIconColor.value = cyanColor;
    } else {
      emailPrefixIconColor.value = blueColor;
    }
  }

  _handlePasswordFocuseChange() {
    if (emailFocusNode.hasFocus) {
      passwordPrefixIconColor.value = cyanColor;
    } else {
      passwordPrefixIconColor.value = blueColor;
    }
  }

  Future<void> loinMethod() async {
    try {
      AuthResponseModel authResponseModel;

      DialogUtils.showLoading(title: "Please Wait");

      final Map<String, dynamic> loginBody = <String, dynamic>{};

      const pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      final regex = RegExp(pattern);

      if (regex.hasMatch(emailController.text.trim())) {
        loginBody["email"] = emailController.text.trim();
      } else {
        loginBody["username"] = emailController.text;
      }

      loginBody["password"] = passwordController.text.trim();

      Response response = await authRepo!.login(loginBody);

      if (response.statusCode == 200) {
        emailController.clear();
        passwordController.clear();
        authResponseModel = AuthResponseModel.fromJson(response.body);

        await authRepo!.saveUserToken(authResponseModel.token.toString());

        ProfileModel profileModel;

        Response responseUserProfile = await authRepo!.getUser();

        DialogUtils.closeLoading();
        if (responseUserProfile.statusCode == 200) {
          profileModel = ProfileModel.fromJson(responseUserProfile.body);
          String userName = profileModel.data!.firstName.toString();
          String designation =
              profileModel.data!.employeeDesignationName.toString();

          String profileImg = profileModel.data!.profileImg.toString();
          await authRepo!.saveUserName(userName, designation);
          await authRepo!.saveProfileImgAndDesignation(profileImg);
          if (profileModel.data?.firstLogin == "1") {
            final String? firstLogin = profileModel.data!.firstLogin;

            authRepo!.saveFirstLogin(firstLogin!);

            Get.offAllNamed(AppRoutes.changePassword);
          } else {
            Get.offAllNamed(AppRoutes.homeScreen);
          }
        }

        drawerController.setCurrentRoute();
      }

      if (response.statusCode == 401) {
        DialogUtils.closeLoading();
        DialogUtils().errorSnackBar("Credentials are incorrect");
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

  void logoutMethod() {
    authRepo?.logout();
    // Get.delete<AuthController>(force: true);
    // Delay disposal slightly to ensure no widget still holds a reference
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.delete<AuthController>();
    });
    Get.offAllNamed(AppRoutes.loginScreen);
    drawerController.setCurrentRoute();
    // Manually open the drawer
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   emailFocusNode.dispose();
  //   passwordFocuseNode.dispose();
  //   print('AuthController Disposed');
  //   super.onClose();
  // }

// Bottom Sheet

  void handleDone(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
