import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/validator.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/auth/controller/auth_controller.dart';
import 'package:trealapp/core/widget/custom_textfield.dart';

class FormWidget extends StatelessWidget {
  FormWidget({super.key});
  // final AuthController controller = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
        // width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 50,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: GetBuilder<AuthController>(
            autoRemove: false,
            builder: (controller) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _textFilds(context, controller),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot Password",
                            style:
                                TextStyles.regular14.copyWith(color: blueColor),
                          )
                        ],
                      ),
                      const SizedBoxHight(
                        hieght: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.loinMethod();
                            TextInput.finishAutofillContext();
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
                          "Login".toUpperCase(),
                          style:
                              TextStyles.regular16.copyWith(color: whiteColor),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  Widget _textFilds(BuildContext context, AuthController controller) {
    return AutofillGroup(
      child: Column(
        children: [
          CustomTextfield(
            // validator: Validator().validateEmail,
            controller: controller.emailController,
            autofillHints: const [AutofillHints.email],
            name: "Enter Your Email or user name",
            prefixIcon: Icons.email,
            inputType: TextInputType.emailAddress,
            focusNode: controller.emailFocusNode,
            prefixIconColor: controller.emailPrefixIconColor.value,
            onFieldSubmitted: (v) {
              FocusScope.of(context)
                  .requestFocus(controller.passwordFocuseNode);
            },
          ),
          CustomTextfield(
            validator: Validator().validatePassword,
            controller: controller.passwordController,
            name: "Enter Your Password",
            autofillHints: const [AutofillHints.password],
            prefixIcon: Icons.password,
            inputType: TextInputType.text,
            focusNode: controller.passwordFocuseNode,
            prefixIconColor: controller.passwordPrefixIconColor.value,
            obscureText: controller.passwordVisible,
            onFieldSubmitted: (v) {
              if (_formKey.currentState!.validate()) {
                controller.handleDone(context);
              }
            },
            suffixIcon: IconButton(
                onPressed: () {
                  controller.passwordVisible = !controller.passwordVisible;
                },
                icon: controller.passwordVisible
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined)),
          ),
        ],
      ),
    );
  }
}
