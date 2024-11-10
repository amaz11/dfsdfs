import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/validator.dart';
import 'package:trealapp/core/widget/custom_textfield.dart';
import 'package:trealapp/module/setting/controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Change Password",
              style: TextStyles.title16.copyWith(color: grayColor)),
          shadowColor: Colors.black26,
          // elevation: 1,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon:
                const Icon(Icons.menu), // You can change this to any other icon
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        // backgroundColor: whiteColor,
        body: Center(
          child: Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              child: GetBuilder<ChangePasswordController>(
                  builder: (changePasswordController) {
                return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextfield(
                            validator: Validator().validatePassword,
                            controller: changePasswordController
                                .currentPasswordController,
                            name: "Current Password",
                            prefixIcon: Icons.password,
                            inputType: TextInputType.text,
                            focusNode:
                                changePasswordController.currentPasswordNode,
                            prefixIconColor: changePasswordController
                                .passwordPrefixIconColor.value,
                            obscureText:
                                changePasswordController.currentPasswordVisible,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(
                                  changePasswordController.newPasswordNode);
                            },
                            suffixIcon: IconButton(
                                onPressed: () {
                                  changePasswordController
                                          .currentPasswordVisible =
                                      !changePasswordController
                                          .currentPasswordVisible;
                                },
                                icon: changePasswordController
                                        .currentPasswordVisible
                                    ? const Icon(Icons.visibility_outlined)
                                    : const Icon(
                                        Icons.visibility_off_outlined)),
                          ),
                          CustomTextfield(
                            validator: Validator().validatePassword,
                            controller:
                                changePasswordController.newPasswordController,
                            name: "New Password",
                            prefixIcon: Icons.password,
                            inputType: TextInputType.text,
                            focusNode: changePasswordController.newPasswordNode,
                            prefixIconColor: changePasswordController
                                .passwordPrefixIconColor.value,
                            obscureText:
                                changePasswordController.newPasswordVisible,
                            onFieldSubmitted: (v) {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).requestFocus(
                                    changePasswordController
                                        .confirmPasswordNode);
                                // changePasswordController.handleDone(context);
                              }
                            },
                            suffixIcon: IconButton(
                                onPressed: () {
                                  changePasswordController.newPasswordVisible =
                                      !changePasswordController
                                          .newPasswordVisible;
                                },
                                icon:
                                    changePasswordController.newPasswordVisible
                                        ? const Icon(Icons.visibility_outlined)
                                        : const Icon(
                                            Icons.visibility_off_outlined)),
                          ),
                          CustomTextfield(
                            validator: Validator().validatePassword,
                            controller: changePasswordController
                                .confirmPasswordController,
                            name: "Confirm Password",
                            prefixIcon: Icons.password,
                            inputType: TextInputType.text,
                            focusNode:
                                changePasswordController.confirmPasswordNode,
                            prefixIconColor: changePasswordController
                                .passwordPrefixIconColor.value,
                            obscureText:
                                changePasswordController.confirmPasswordVisible,
                            onFieldSubmitted: (v) {
                              if (_formKey.currentState!.validate()) {
                                changePasswordController.handleDone(context);
                              }
                            },
                            suffixIcon: IconButton(
                                onPressed: () {
                                  changePasswordController
                                          .confirmPasswordVisible =
                                      !changePasswordController
                                          .confirmPasswordVisible;
                                },
                                icon: changePasswordController
                                        .confirmPasswordVisible
                                    ? const Icon(Icons.visibility_outlined)
                                    : const Icon(
                                        Icons.visibility_off_outlined)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  changePasswordController
                                      .passwordChangeMethod();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blueColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(6), // <-- Radius
                                ),
                                minimumSize: const Size(200, 40),
                              ),
                              child: Text(
                                "Update Password".toUpperCase(),
                                style: TextStyles.regular16
                                    .copyWith(color: whiteColor),
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
              })),
        ),
      ),
    );
  }
}
