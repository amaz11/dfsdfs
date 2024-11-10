import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  var borderColor = blueColor.obs;
  bool isLoading = false; // Reactive border color

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void startAnimation() {
    animationController.forward();
  }

  void reverseAnimation() {
    animationController.reverse();
  }

  void toggleBorderColor() {
    isLoading = !isLoading;
    borderColor.value = borderColor.value == blueColor ? cyanColor : blueColor;
  }
}
