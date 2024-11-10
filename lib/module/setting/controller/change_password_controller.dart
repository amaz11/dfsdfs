import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/module/setting/model/change_password_model.dart';
import 'package:trealapp/module/setting/repo/change_password_repo.dart';

class ChangePasswordController extends GetxController {
  late ChangePasswordRepo? changePasswordRepo;
  ChangePasswordController({this.changePasswordRepo});
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode currentPasswordNode = FocusNode();
  final FocusNode newPasswordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  final RxBool currentObscureText = true.obs;
  final RxBool newObscureText = true.obs;
  final RxBool confirmObscureText = true.obs;
  Rx<Color> passwordPrefixIconColor = blueColor.obs;
  late bool result = false;

  set currentPasswordVisible(bool value) {
    currentObscureText.value = value;
    update();
  }

  set newPasswordVisible(bool value) {
    newObscureText.value = value;
    update();
  }

  set confirmPasswordVisible(bool value) {
    confirmObscureText.value = value;
    update();
  }

  bool get currentPasswordVisible => currentObscureText.value;
  bool get newPasswordVisible => newObscureText.value;
  bool get confirmPasswordVisible => confirmObscureText.value;

  void onInt() {
    super.onInit();
    currentPasswordNode.addListener(_handleCurrentPasswordFocuseChange);
    newPasswordNode.addListener(_handleNewPasswordFocuseChange);
    confirmPasswordNode.addListener(_handleConfirmPasswordFocuseChange);
    result = currentPasswordNode.hasFocus;
  }

  _handleCurrentPasswordFocuseChange() {
    if (currentPasswordNode.hasFocus) {
      passwordPrefixIconColor.value = cyanColor;
    } else {
      passwordPrefixIconColor.value = blueColor;
    }
  }

  _handleNewPasswordFocuseChange() {
    if (newPasswordNode.hasFocus) {
      passwordPrefixIconColor.value = cyanColor;
    } else {
      passwordPrefixIconColor.value = blueColor;
    }
  }

  _handleConfirmPasswordFocuseChange() {
    if (confirmPasswordNode.hasFocus) {
      passwordPrefixIconColor.value = cyanColor;
    } else {
      passwordPrefixIconColor.value = blueColor;
    }
  }

  Future<void> passwordChangeMethod() async {
    final Map<String, dynamic> passwordChangeBody = <String, dynamic>{};
    passwordChangeBody['current_password'] =
        currentPasswordController.text.trim();
    passwordChangeBody['new_password'] = newPasswordController.text.trim();
    passwordChangeBody['new_password_confirmation'] =
        confirmPasswordController.text.trim();
    try {
      ChangePasswordModel changePasswordModel;
      DialogUtils.showLoading(title: "Please Wait");
      Response response =
          await changePasswordRepo!.changePassword(passwordChangeBody);
      DialogUtils.closeLoading();
      if (response.statusCode == 200) {
        changePasswordRepo?.removeFirstLogin();
        changePasswordModel = ChangePasswordModel.fromJson(response.body);
        String? message = changePasswordModel.message;

        Get.offAllNamed(AppRoutes.homeScreen);
        DialogUtils().sucessSnackBar(message!);
      }
    } catch (e) {
      DialogUtils().errorSnackBar("An error occurred: $e");
    }
  }

  void handleDone(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
