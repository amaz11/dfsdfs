// ignore: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/module/auth/repo/auth_repo.dart';
import 'package:trealapp/module/home/model/approver_check_modal.dart';
import 'package:trealapp/module/home/repo/landing_page_repo.dart';
import 'package:trealapp/module/notification/controller/notification_controller.dart';

class LandingController extends GetxController {
  AuthRepo? authRepo;
  LandingPageRepo? landingPageRepo;

  LandingController({this.authRepo, this.landingPageRepo});

  var tabIndex = 0.obs;
  final RxString userName = "".obs;
  final RxString greetingValue = "".obs;
  var listOfStrings = <String>[].obs;
  late Timer timer;

  RxBool canManageLeave = false.obs;
  RxBool canManageExpense = false.obs;

  RxBool isApproverLoading = true.obs;

  late PageController pageController;
  late final NotificationController _notificationController;

  RxInt notificatitonUreadDataLength = 0.obs;

  final List<IconData> listOfIcons = [
    Icons.home_outlined,
    Icons.access_time,
    Icons.description_outlined,
    Icons.monetization_on_outlined
  ];
  void changeTabIndex(int index) {
    tabIndex.value = index;
    pageController.jumpToPage(index);
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    _notificationController = Get.find<NotificationController>();
    checkApproverMethod();
    _getNameAndGreeting();
  }

  void _getNameAndGreeting() async {
    await getUserInfoMethod();

    await _notificationController.getNotificationMethod();
    notificatitonUreadDataLength.value =
        _notificationController.notificationData.length;
    update();
  }

  void goToPage(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        changeTabIndex(index);
      } else {
        Get.snackbar("Error", "PageController is not attached.");
      }
    });
  }

  Future<void> startGreeting() async {
    await _getGreeting();
    update();
    timer = Timer.periodic(const Duration(hours: 1), (timer) async {
      await _getGreeting();
      update();
    });
  }

  Future<void> getUserInfoMethod() async {
    try {
      String? name = authRepo!.getUserName();
      await startGreeting();
      userName.value = '$name, ${greetingValue.value}';
      updateListOfStrings();
      update();
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

  Future<void> _getGreeting() async {
    try {
      // var currentTime = await UtcTimeApi().fetchAccurateTime();
      String currentTime =
          DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now());
      DateTime dateTime = DateFormat('MM/dd/yyyy hh:mm a').parse(currentTime);
      int hour = dateTime.hour;
      if (hour >= 5 && hour < 12) {
        greetingValue.value = 'Good Morning';
        update();
      } else if (hour >= 12 && hour < 18) {
        greetingValue.value = 'Good Afternoon';
        update();
      } else if (hour >= 18 && hour <= 23) {
        greetingValue.value = 'Good Evening';
        update();
      } else {
        greetingValue.value = 'Good Night'; // Default greeting
        update();
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

  void updateListOfStrings() {
    listOfStrings.value = [
      userName.value,
      "Attendance Report",
      "Expense",
      canManageLeave.value || canManageExpense.value ? "Approval" : "Calender",
    ];
    update();
  }

// API methods
  Future<void> checkApproverMethod() async {
    try {
      isApproverLoading(true);
      Response response = await landingPageRepo!.getCheckApproval();

      if (response.statusCode == 200) {
        ApprovalCheckModal approvalCheckModal =
            ApprovalCheckModal.fromJson(response.body);
        canManageLeave.value = approvalCheckModal.data!.canManageLeave!;
        canManageExpense.value = approvalCheckModal.data!.canManageExpense!;
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    } finally {
      isApproverLoading(false);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
