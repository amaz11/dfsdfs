import 'package:flutter/material.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:get/get.dart';
import 'package:trealapp/module/attendence/controller/animation_button_contrroller.dart';
import 'package:trealapp/module/dashboard/controller/dashboard_conroller.dart';

class AttendenceWidget extends StatelessWidget {
  AttendenceWidget({super.key});
  final DashboardController controller = Get.put(DashboardController());
  final AnimatedButtonController animationController =
      Get.find<AnimatedButtonController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.20,
              blurRadius: 2,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_timeDetails(context), _checkGesture()],
      ),
    );
  }

  // left side of Attendence of row
  Widget _timeDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            animationController.checkInOutText.value == "Check Out"
                ? "Accomplished Office ?"
                : "Reached Office ?",
            style: TextStyles.title16,
          ),
        ),
        Obx(
          () => Text(
            animationController.checkInOutText.value == "Check Out"
                ? "Attendance Recorded"
                : "Give Attendeance",
            style: TextStyles.title12.copyWith(color: lightGrayColor),
          ),
        ),
        const SizedBoxHight(
          hieght: 5,
        ),
        // animationController.todayCheckInTime.value
        Obx(() => _time(context, "Today In Time",
            animationController.todayCheckInTime.value)),
        const SizedBoxHight(
          hieght: 6,
        ),
        Obx(() => _time(context, "Today Out Time",
            animationController.todayCheckOutTime.value)),
      ],
    );
  }

  Widget _time(BuildContext context, String timeText, String time) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 0.9,
            color: lightGrayColor2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 2.5, bottom: 2.5),
      width: screenWidth * .58,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            timeText,
            style: TextStyles.regular12
                .copyWith(fontWeight: FontWeight.w600, color: lightGrayColor),
          ),
          Text(
            time,
            style: TextStyles.regular12
                .copyWith(fontWeight: FontWeight.w600, color: lightGrayColor),
          )
        ],
      ),
    );
  }

  // right side of Attendence of row
  Widget _checkGesture() {
    return GestureDetector(
      onTap: () async {
        Get.toNamed(
          AppRoutes.attdenceSubmitScreen,
        );
        await animationController.reFatchGetCurrentlocation();
      },
      child: Obx(() => Container(
            decoration: BoxDecoration(
              color: animationController.todayCheckInOutColor.value,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            width: 110,
            height: 125,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.touch_app_outlined,
                  size: 66,
                  color: whiteColor,
                ),
                const SizedBoxHight(
                  hieght: 5,
                ),
                Flexible(
                  child: Text(
                    animationController.checkInOutText.value,
                    style: TextStyles.title14.copyWith(color: whiteColor),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
