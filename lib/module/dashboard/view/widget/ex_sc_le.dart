import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/module/home/controller/landing_controller.dart';

class ExScLe extends StatelessWidget {
  ExScLe({super.key});
  final LandingController landingController = Get.find<LandingController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: exSeLeBox(
                Icons.monetization_on_outlined, cyanColor, "Expense", "", 2)),
        SizedBox(
          width: Dimensions.padding05,
        ),
        Expanded(
            child: exSeLeBox(Icons.calendar_month_outlined, blueColor,
                "Calender", AppRoutes.holidays, 0)),
        SizedBox(
          width: Dimensions.padding05,
        ),
        Expanded(
            child: exSeLeBox(Icons.description_outlined, orangeColor, "Leave",
                AppRoutes.leaveSummary, 0)),
      ],
    );
  }

  Widget exSeLeBox(IconData ionc, Color color, String name, String path,
      int pageViewNumber) {
    return GestureDetector(
      onTap: () {
        if (path.isEmpty) {
          landingController.pageController.jumpToPage(pageViewNumber);
          landingController.changeTabIndex(pageViewNumber);
        } else {
          Get.toNamed(path);
        }
      },
      child: Container(
        height: Dimensions.height45,
        decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(color: lightGrayColor2.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(Dimensions.radius12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.20,
                blurRadius: 3,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ]),
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              ionc,
              color: color,
              size: Dimensions.icon24,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              name,
              style: TextStyles.title14,
            )
          ],
        ),
      ),
    );
  }
}
