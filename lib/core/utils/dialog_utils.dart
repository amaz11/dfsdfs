import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/assets_path.dart';

class DialogUtils {
  static void showLoading({required String title}) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  loadingGif,
                  colorBlendMode: BlendMode.lighten,
                ),
                // const CircularProgressIndicator(
                //   backgroundColor: whiteColor,
                //   color: blueColor,
                // ),
                // SizedBox(height: 16),
                // Text(title),
              ],
            ),
          ),
        );
      },
    );
  }

  static void closeLoading() {
    Navigator.of(Get.context!).pop();
  }

  static void successMessage({required String title}) {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
              ),
              // padding:
              //     const EdgeInsets.symmetric(horizontal: 32, vertical: 72),
              // margin:
              //     const EdgeInsets.symmetric(horizontal: 32, vertical: 72),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check, color: Colors.green, size: 96),
                  Center(
                    child: Text(
                      title.isEmpty ? "Success" : title,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        // barrierDismissible: true,
        );
    // Close the dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      closeLoading();
    });
  }

  void showDeleteConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: content,
      middleTextStyle: const TextStyle(fontSize: 16),
      radius: 15,
      textConfirm: "Yes, Delete",
      confirmTextColor: Colors.white,
      textCancel: "Cancel",
      cancelTextColor: Colors.black,
      buttonColor: Colors.red,
      onConfirm: onConfirm,
    );
  }

  void showConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
    required Color colors,
    required String text,
    Widget? widget,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: content,
      middleTextStyle: const TextStyle(fontSize: 16),
      radius: 15,
      textConfirm: text,
      content: widget,
      confirmTextColor: Colors.white,
      textCancel: "Cancel",
      cancelTextColor: Colors.black,
      buttonColor: colors,
      onConfirm: onConfirm,
    );
  }

  void getxSnackBar(String title, message, Color backgroundColor,
      Color linearColor, IconData icon, Color iconColor) {
    Get.snackbar(title, "",
        messageText: Text(
          "$message",
          style: TextStyles.regular14.copyWith(fontWeight: FontWeight.w500),
        ),
        colorText: grayColor,
        barBlur: 0,
        backgroundColor: backgroundColor,
        borderWidth: 1,
        borderColor: whiteColor,
        boxShadows: [
          BoxShadow(
              color: lightGrayColor2.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 8,
              offset: const Offset(0, 2))
        ],
        backgroundGradient: LinearGradient(
          colors: [
            linearColor,
            linearWhiteColor
          ], // Define your gradient colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        overlayBlur: 0,
        shouldIconPulse: false,
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ));
  }

  void errorSnackBar(message) {
    getxSnackBar("Error meassage", message, redColor, errorRedColor,
        Icons.error, redColor);
  }

  void sucessSnackBar(message) {
    getxSnackBar("Success meassage", message, cyanColor, successColor,
        Icons.check_circle, cyanColor);
  }

  void warningSnackbar(message) {
    getxSnackBar("Warning meassage", message, orangeColor, warningColor,
        Icons.warning, orangeColor);
  }

  void infoSnackbar(message) {
    getxSnackBar("Informative meassage", message, blueColor, infoColor,
        Icons.info, blueColor);
  }
}
