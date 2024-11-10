import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/module/attendence/controller/location_controller.dart';
import 'package:trealapp/module/attendence/model/today_attendence_check_model.dart';
import 'package:trealapp/module/attendence/repo/attendence_submit_repo.dart';

class AnimatedButtonController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AttendenceSubmitRepo? attendenceSubmitRepo;
  AnimatedButtonController({this.attendenceSubmitRepo});
  final LocationController locationController = Get.find<LocationController>();
  late Animation<double> animation;
  late AnimationController controller;
  final RxBool todayCheckIn = false.obs;
  final RxString todayCheckInOutText = "Tap and hold to Check In".obs;
  final Rx<Color> todayCheckInOutColor = blueColor.obs;
  final RxString checkInOutText = "Check In".obs;
  final RxBool todayCheckInOutComplete = false.obs;
  final RxString todayCheckInTime = "N/A".obs;
  final RxString todayCheckOutTime = "N/A".obs;
  @override
  void onInit() {
    super.onInit();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    todayAttendence();
    // Listen for changes in todayCheckInOutComplete
    ever(todayCheckInOutComplete, (_) => updateAnimation());

    // Initially update the animation based on the initial value
    updateAnimation();
  }

  void updateAnimation() {
    if (todayCheckInOutComplete.value) {
      animation = Tween<double>(begin: 0, end: 0).animate(controller)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            onComplete();
            controller.reset();
          }
        });
    } else {
      animation = Tween<double>(begin: 0, end: 1).animate(controller)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            onComplete();
            controller.reset();
          }
        });
    }
  }

  Future<void> reFatchGetCurrentlocation() async {
    await locationController.getCurrentLocation();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void onComplete() async {
    if (todayCheckIn.value == false) {
      await locationController.checkInSubmitMethod();
      await todayAttendence();
    } else {
      await locationController.checkOutSubmitMethod();
      await todayAttendence();
    }
  }

  Future<void> todayAttendence() async {
    try {
      Response response = await attendenceSubmitRepo!.userTodayAttendence();

      if (response.statusCode == 200) {
        final TodayAttendenceCheckModel todayAttendenceCheckModel;
        todayAttendenceCheckModel =
            TodayAttendenceCheckModel.fromJson(response.body);
        if (todayAttendenceCheckModel.data!.checkIn!.isNotEmpty &&
            todayAttendenceCheckModel.data!.checkOut == null) {
          todayCheckIn.value = true;
          todayCheckInOutText.value = "Tap and hold to Check Out";
          todayCheckInOutColor.value = redColor;
          checkInOutText.value = "Check Out";
          //  check-in time
          todayCheckInTime.value =
              locationController.timeConverterToHousAndMinute(
                  todayAttendenceCheckModel.data!.checkIn!);
          locationController.officeTimeInHeading.value = "Check In";
          locationController.officeTimeIn.value = todayCheckInTime.value;
          update();
        } else {
          todayCheckInOutText.value =
              "Well done!! \n You've wrapped up your day!";
          todayCheckInOutColor.value = cyanColor;
          todayCheckInOutComplete.value = true;
          checkInOutText.value = "Complete!!";

          //  check-in time
          todayCheckInTime.value =
              locationController.timeConverterToHousAndMinute(
                  todayAttendenceCheckModel.data!.checkIn!);

          //  check-Out time
          todayCheckOutTime.value =
              locationController.timeConverterToHousAndMinute(
                  todayAttendenceCheckModel.data!.checkOut!);

          locationController.officeTimeInHeading.value = "Check In";
          locationController.officeTimeIn.value = todayCheckInTime.value;
          locationController.officeTimeOutHeading.value = "Check Out";
          locationController.officeTimeOut.value = todayCheckOutTime.value;
          update();
        }
      }
      // DialogUtils.closeLoading();
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

  void startAnimation() {
    controller.reset();
    controller.forward();
  }

  void resetAnimation() {
    controller.reset();
  }

  Future<void> onRefreshing() async {
    await locationController.getCurrentLocation();
    await todayAttendence();
  }
}
