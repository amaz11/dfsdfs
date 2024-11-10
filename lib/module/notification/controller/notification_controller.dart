import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/notification/model/notification_model.dart';
import 'package:trealapp/module/notification/repo/notification_repo.dart';

class NotificationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  NotificationRepo? notificationRepo;

  NotificationController({this.notificationRepo}) {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        // Detect swipe
        setTabAndFetch(tabController.index);
      }
    });
  }

  final RxString page = "1".obs;
  final RxString perPage = "20".obs;
  final RxString notificationStatus = "all".obs;
  var notificationData = <NotificationData>[].obs;
  var isLoading = false.obs;
  RxInt currentTabIndex = 0.obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    // Initial fetch
    getNotificationMethod();
  }

  Future<void> getNotificationMethod() async {
    try {
      isLoading(true);
      NotificationModel notificationModel;
      Response response = await notificationRepo!.getNotifications(
          page.value, perPage.value, notificationStatus.value);
      if (response.statusCode == 200) {
        notificationModel = NotificationModel.fromJson(response.body);
        if (notificationModel.data != null) {
          notificationData.value = notificationModel.data!;
          update();
        }
      }
    } catch (e) {
      DialogUtils().errorSnackBar("$e");
    } finally {
      isLoading(false);
    }
  }

  void setTabAndFetch(int index) async {
    currentTabIndex.value = index;
    switch (index) {
      case 0:
        notificationStatus.value = "all";
        break;
      case 1:
        notificationStatus.value = "read";
        break;
      case 2:
        notificationStatus.value = "unread";
        break;
    }
    notificationData.value = [];
    await getNotificationMethod();
  }

  // Method to change the notification status
  void changeNotificationStatus(String status) {
    notificationStatus.value = status;
    page.value = "1"; // Reset to the first page
    getNotificationMethod();
  }

  Future<void> getUnreadNotificationMethod() async {
    notificationStatus.value = "unread";
    notificationData.value = [];
    await getNotificationMethod();
  }

  Future<void> showModal(NotificationData notification) async {
    try {
      Response response =
          await notificationRepo!.readNotification(notification.id!);
      if (response.statusCode == 200) {
        Get.dialog(Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              width: Dimensions.widthScreen90,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(
                  left: 32, right: 32, bottom: 30, top: 30),
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 72),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? "N/A",
                    style: TextStyles.title16.copyWith(color: grayColor),
                  ),
                  const SizedBoxHight(
                    hieght: 10,
                  ),
                  Text(
                    notification.message ?? "N/A",
                    style: TextStyles.regular14.copyWith(color: grayColor),
                  ),
                ],
              ),
            ),
          ),
        ));
        getNotificationMethod();
      }
    } catch (e) {
      DialogUtils().errorSnackBar("Failed to read notification: $e");
    }
  }
}
