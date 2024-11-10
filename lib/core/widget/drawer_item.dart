import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/module/home/controller/landing_controller.dart';

// ignore: must_be_immutable
class DrawerItem extends StatelessWidget {
  String title;
  IconData icon;
  String? path;
  bool homeScreen;
  int? pageViewNumber;
  DrawerItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.path,
      this.homeScreen = false,
      this.pageViewNumber = 0});
  final LandingController controller = Get.find<LandingController>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ListTile(
        contentPadding: const EdgeInsets.only(left: 1),
        minTileHeight: 48,
        horizontalTitleGap: 5,
        leading: Icon(
          icon,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyles.regular16Thin300,
        ),
        onTap: () {
          // Navigate based on the homeScreen flag
          Scaffold.of(context).closeDrawer();

          if (homeScreen) {
            // Ensure pageViewNumber is not null (you might want to handle this better)
            if (pageViewNumber != null) {
              Get.offAllNamed(path!);
              // Use a Future to delay the jumpToPage call
              // Get.offAllNamed(AppRoutes.homeScreen);
              Future.delayed(const Duration(milliseconds: 300), () {
                if (controller.pageController.hasClients) {
                  controller.goToPage(pageViewNumber!);
                  // controller.changeTabIndex(pageViewNumber!);
                } else {
                  Get.snackbar("Error", "PageController is not attached.");
                }
              });
            } else {
              Get.snackbar("Error", "Page view number is not defined.");
            }
          } else {
            // Ensure path is not null before navigation
            if (path != null) {
              Get.toNamed(path!);
            } else {
              Get.snackbar("Error", "Path is not set for navigation.");
            }
          }
        },
      );
    });
  }
}
